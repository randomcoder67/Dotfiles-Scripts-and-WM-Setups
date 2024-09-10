use std::io::{BufWriter, Write};
use std::fs::File;

pub fn write_to_file(name: &str, icon: &str, icon_path: &str, f: &mut BufWriter<File>) {
	f.write(name.as_bytes()).unwrap();
	f.write(&[0x00]).unwrap();
	f.write("icon".as_bytes()).unwrap();
	f.write(&[0x1F]).unwrap();
	f.write(icon_path.as_bytes()).unwrap();
	f.write(icon.as_bytes()).unwrap();
	f.write(&[0x0A]).unwrap();
}

pub fn replace_tilde_with_home_dir(mut input: String, home_dir: &str) -> String {
	if input.starts_with("~") {
		input = input.replacen("~", home_dir, 1);
	}
	input
}


pub fn replace_home_dir_with_tilde(mut input: String, home_dir: &str) -> String {
	if input.starts_with(home_dir) {
		input = input.replacen(home_dir, "~", 1);
	}
	input
}
