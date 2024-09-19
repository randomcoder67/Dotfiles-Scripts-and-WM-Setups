use crate::helpers::write_to_file;
use crate::reindex::Config;
use std::fs::{File, read_dir};
use std::path::PathBuf;
use std::io::BufWriter;
use std::collections::HashMap;
use std::env;

pub fn reindex_files(conf: &Config, home_dir: &str, f: &mut BufWriter<File>) {
	
	let mut ignore_dirs = Vec::new();
	for ignore in conf.ignore_locations.clone() {
		ignore_dirs.push(ignore.replacen("~", home_dir, 1));
	}
	
	let mut files: Vec<(String, String)> = Vec::new();
	for mut dir in conf.check_locations.clone() {
		if dir.starts_with("~") {
			dir = dir.replacen("~", home_dir, 1);
		}
		files = do_read_dir(&dir, &conf.allowed_extensions, files, &ignore_dirs, false);
	}
	
	for mut dir in conf.check_locations_recursive.clone() {
		if dir.starts_with("~") {
			dir = dir.replacen("~", home_dir, 1);
		}
		files = do_read_dir(&dir, &conf.allowed_extensions, files, &ignore_dirs, true);
	}
	
	save_to_file(files, conf.icon_path.clone(), &conf.file_extension_icons, f);
}

fn save_to_file(mut files: Vec<(String, String)>, mut icon_path: String, file_extension_icons: &HashMap<String, String>, f: &mut BufWriter<File>) {
	icon_path.push_str("/mimetypes/");
	files.sort_by(|a, b| a.0.to_lowercase().cmp(&b.0.to_lowercase()));
	
	let home = env::var("HOME").expect("what");
	
	for (mut name, ext) in files {
		let mut icon_name = "text-plain.svg";
		if file_extension_icons.contains_key(&ext) {
			icon_name = &file_extension_icons[&ext];
		}
		name = name.replace(&home, "~");
		write_to_file(&name, icon_name, &icon_path, f);
	}
}

pub fn do_read_dir(dir: &str, allowed_extensions: &Vec<String>, mut files: Vec<(String, String)>, ignore_dirs: &Vec<String>, recursive: bool) -> Vec<(String, String)> {
	let mut path = PathBuf::from(dir);
	files = read_recursive(&mut path, allowed_extensions, files, ignore_dirs, recursive);
	files
}

fn read_recursive(path: &mut PathBuf, allowed_extensions: &Vec<String>, mut files: Vec<(String, String)>, ignore_dirs: &Vec<String>, recursive: bool) -> Vec<(String, String)> {
	for ignore in ignore_dirs {
		if path.to_str().unwrap() == ignore {
			return files;
		}
	}
	
	let contents = match read_dir(&path) {
		Ok(c) => c,
		Err(_) => return files,
	};
	for f in contents {
		let file = match f {
			Ok(a) => a,
			Err(_) => continue,
		};
		let file_type = match file.file_type() {
			Ok(t) => t,
			Err(_) => continue,
		};
		let entry_name = file.file_name().into_string().unwrap();
		if file_type.is_dir() && recursive {
			path.push(entry_name);
			files = read_recursive(path, allowed_extensions, files, ignore_dirs, recursive);
			path.pop();
		} else if file_type.is_file() {
			for ext in allowed_extensions {
				if entry_name.ends_with(ext) {
					let full_name = format!("{}/{}", path.as_os_str().to_str().unwrap(), entry_name);
					files.push((full_name, ext.clone()));
					break;
				}
			}
		}
	}
	files
}
