use crate::reindex::Config;
use crate::helpers::write_to_file;
use toml::Value;
use std::io::BufWriter;
use std::fs::File;
use serde::Deserialize;
use std::collections::HashMap;
use std::env;

const LAUNCHER_FILE_LOC: &str = "/.config/rc67/rofi_launcher_programs.toml";

#[derive(Debug)]
pub struct ProgramEntry {
	name: String,
	icon: String,
}

#[derive(Deserialize)]
struct ParsedLauncher {
	#[serde(alias="Programs")]
	programs: Option<HashMap<String, HashMap<String, Value>>>,
	#[serde(alias="Aliases")]
	aliases: Option<HashMap<String, String>>,
}	

pub fn get_launcher_file_data() -> (HashMap<String, HashMap<String, Value>>, HashMap<String, String>) {
	let mut parsed_launcher = parse_launcher_toml();
	let programs = match parsed_launcher.programs {
		Some(m) => m,
		None => HashMap::new(),
	};
	let aliases = match parsed_launcher.aliases {
		Some(m) => m,
		None => HashMap::new(),
	};
	
	(programs, aliases)
}

pub fn parse_launcher_for_programs(parsed_launcher: ParsedLauncher, parse_cmds: bool) -> Vec<ProgramEntry> {
	let mut entries: Vec<ProgramEntry> = Vec::new();
	let mut programs_map = match parsed_launcher.programs {
		Some(m) => m,
		None => return entries,
	};
	
	println!("{:?}", parsed_launcher.aliases);
	 
	for entry in programs_map {
		let (name, mut data) = entry;
		let icon = match data.remove("icon") {
			Some(Value::String(s)) => s,
			_ => panic!("Missing valid icon for {}", name),
		};
		
		let e = ProgramEntry {
			name,
			icon,
		};
		entries.push(e);
	}
	
	entries
}

pub fn add_programs(conf: &Config, f: &mut BufWriter<File>) {
	let parsed_launcher = parse_launcher_toml();
	let mut programs = parse_launcher_for_programs(parsed_launcher, false);
	let icon_path = format!("{}/{}/", conf.icon_path, "apps");
	
	programs.sort_by(|a, b| a.name.to_lowercase().cmp(&b.name.to_lowercase()));

	for program in programs {
		write_to_file(&program.name, &program.icon, &icon_path, f);
	}
}

fn parse_launcher_toml() -> ParsedLauncher {
	let home = env::var("HOME").expect("why is $HOME undefined");
	let file = format!("{}{}", home, LAUNCHER_FILE_LOC);
	let launcher_text = match std::fs::read_to_string(&file) {
		Ok(c) => c,
		Err(e) => panic!("{}", e),
	};
	
	let parsed_launcher: ParsedLauncher = match toml::from_str(&launcher_text) {
		Ok(t) => t,
		Err(e) => panic!("{}", e),
	};
	parsed_launcher
}
