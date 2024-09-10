mod helpers;
mod reindex;
mod file_index;
mod programs;
mod rofi;
use rofi::{launch_rofi, Status};
use reindex::{reindex, parse_config, Config};
use programs::get_launcher_file_data;
use std::collections::HashMap;
use toml::Value;
use std::process::Command;
use helpers::replace_tilde_with_home_dir;

use std::env;

fn launch_program(program: &mut HashMap<String, Value>, mut aliases: HashMap<String, String>, status: Status, home_dir: &str) {
	let mut cmd = match program.remove("cmd") {
		Some(Value::Array(t)) => t,
		Some(_) => panic!("Wrong format for cmds"),
		None => panic!("No cmd"),
	};
	
	if cmd.len() == 0 {
		panic!("Error, empty cmd array");
	}
	
	let mut program_name = match cmd.remove(0) {
		Value::String(s) => s,
		_ => panic!("Error, not a string"),
	};
	
	if program_name.starts_with("$") {
		println!("here");
		program_name.remove(0);
		program_name = match aliases.remove(&program_name) {
			Some(s) => s,
			_ => panic!("Unknown alias"),
		};
	}
	program_name = replace_tilde_with_home_dir(program_name, home_dir);
	
	let mut to_run = Command::new(program_name);
	
	for arg in cmd {
		match arg {
			Value::String(s) => {
				to_run.arg(s);
			},
			_ => panic!("Invalid command format"),
		}
	}
	
	to_run.spawn();
}

fn open_file(mut filename: String, status: Status, home_dir: &str) {
	if filename.starts_with("~") {
		filename.remove(0);
		filename.insert_str(0, home_dir);
	}
	println!("{}, {:?}, {}", filename, status, home_dir);
	let mut to_run = Command::new("xdg-open");
	to_run.arg(filename);
	to_run.spawn();
}

fn run_rofi(icons: bool, home_dir: &str) {
	let home = env::var("HOME").expect("why is $HOME undefined");
	let file = format!("{}/.cache/rc67/files.txt", home);
	let (stdout, status) = launch_rofi(&file, "Launcher", icons);
	let (mut programs, mut aliases) = get_launcher_file_data();
	
	if status != Status::Enter {
		return;
	}
	
	if programs.contains_key(&stdout) {
		launch_program(&mut programs.remove(&stdout).unwrap(), aliases, status, home_dir);
	} else {
		open_file(stdout, status, home_dir);
	}
}

fn main() {
	let conf: Config = parse_config();
	let home_dir = match env::var("HOME") {
		Ok(s) => s,
		Err(e) => panic!("{}", e),
	};
	if home_dir == "" {
		panic!("Empty HOME env");
	}
	
	let args: Vec<String> = env::args().collect();
	match args.len() {
		1 => run_rofi(conf.icons, &home_dir),
		_ => {
			match args[1].as_str() {
				"--reindex" => {
					if args.len() == 3 && args[2] == "-m" {
						reindex(&home_dir, conf, true);
					} else {
						reindex(&home_dir, conf, false);
					}
				},
				_ => (),
			}
		},
	}
}
