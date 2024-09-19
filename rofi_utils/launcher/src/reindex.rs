use crate::file_index::reindex_files;
use crate::programs::add_programs;
use serde::Deserialize;
use std::io::{BufWriter, Write};
use std::fs::File;
use std::process::Command;
use std::collections::HashMap;
use std::env;

const CONFIG_FILE_LOC: &str = "/.config/rc67/rofi_launcher_config.toml";

#[derive(Debug)]
pub struct Config {
	pub _check_interval: u32,
	pub icons: bool,
	pub check_locations_recursive: Vec<String>,
	pub check_locations: Vec<String>,
	pub ignore_locations: Vec<String>,
	pub icon_path: String,
	pub allowed_extensions: Vec<String>,
	pub file_extension_icons: HashMap<String, String>,
}

#[derive(Deserialize)]
struct ParsedConfig {
	check_interval: Option<u32>,
	icons: Option<bool>,
	check_locations_recursive: Option<Vec<String>>,
	check_locations: Option<Vec<String>>,
	ignore_locations: Option<Vec<String>>,
	icon_path: Option<String>,
	allowed_extensions: Option<Vec<String>>,
	file_extension_icons: Option<HashMap<String, String>>,
}

pub fn reindex(home_dir: &str, conf: Config, manual: bool) {
	let home = env::var("HOME").expect("why is $HOME undefined");
	let file = format!("{}/.cache/rc67/files.txt", home);
	let f = File::create(&file).expect("Unable to create output file");
	let mut f = BufWriter::new(f);
	
	add_programs(&conf, &mut f);
	
	reindex_files(&conf, home_dir, &mut f);
	
	match f.flush() {
		Err(e) => panic!("{}", e),
		_ => (),
	}
	if manual {
		Command::new("notify-send").arg("Redindexed files").output();
	}
}

pub fn parse_config() -> Config {
	let home = env::var("HOME").expect("why is $HOME undefined");
	let file = format!("{}{}", home, CONFIG_FILE_LOC);
	let config_text = match std::fs::read_to_string(&file) {
		Ok(c) => c,
		Err(e) => panic!("{}", e),
	};
	
	let parsed_config: ParsedConfig = toml::from_str(&config_text).unwrap();
	
	let check_locations = match parsed_config.check_locations {
		Some(v) => v,
		None => Vec::new(),
	};
	
	let check_locations_recursive = match parsed_config.check_locations_recursive {
		Some(v) => v,
		None => Vec::new(),
	};

	let ignore_locations = match parsed_config.ignore_locations {
		Some(v) => v,
		None => Vec::new(),
	};
	
	let icons = match parsed_config.icons {
		Some(b) => b,
		None => false,
	};
	
	let check_interval = match parsed_config.check_interval {
		Some(u) => u,
		None => 900,
	};
	
	let icon_path = match parsed_config.icon_path {
		Some(s) => s,
		None => panic!("Specify icon_path in config file"),
	};
	
	let allowed_extensions = match parsed_config.allowed_extensions {
		Some(a) => a,
		None => Vec::new(),
	};
	
	let file_extension_icons = match parsed_config.file_extension_icons {
		Some(m) => m,
		None => HashMap::new(),
	};
	
	Config {
		_check_interval: check_interval,
		icons,
		check_locations_recursive,
		check_locations,
		ignore_locations,
		icon_path,
		allowed_extensions,
		file_extension_icons,
	}
}
