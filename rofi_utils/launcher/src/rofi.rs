use std::process::Command;

#[derive(Debug, PartialEq)]
pub enum Status {
    Enter,
    ShiftEnter,
    CtrlA,
    CtrlW,
    Cancel,
    Custom,
}

pub fn launch_rofi(input_file: &str, prompt: &str, icons: bool) -> (String, Status) {
    let mut rofi_cmd = Command::new("rofi");
    rofi_cmd.arg("-dmenu") // dmenu mode
        .arg("-i") // case insensitive
        .arg("-input") // use input file instead of stdin
        .arg(input_file)
        .arg("-p") // custom prompt
        .arg(prompt)
        .arg("-refilter-timeout-limit") // Allow up to 10000 entries before introducing a delay before re-searching
        .arg("10000")
        .arg("-kb-custom-1") // Custom keyboard 1: Shift+Return
        .arg("Shift+Return")
        .arg("-kb-custom-2") // Custom keyboard 2: Ctrl+a
        .arg("Ctrl+a")
        .arg("-kb-custom-3") // Custom keyboard 3: Ctrl+w
        .arg("Ctrl+w")
        .arg("-format")
        .arg("i - s");
    
    if icons {
    	rofi_cmd.arg("-show-icons");
    }
    
    let output = match rofi_cmd.output() {
    	Ok(o) => o,
    	Err(e) => panic!("{}", e),
    };
    
    let mut status = match output.status.code() {
    	Some(0) => Status::Enter,
    	Some(10) => Status::ShiftEnter,
    	Some(11) => Status::CtrlA,
    	Some(12) => Status::CtrlW,
    	Some(1) => Status::Cancel,
    	Some(i) => panic!("Return code: {}", i),
    	None => panic!("No return code"),
    };
    
    let mut stdout: String = std::str::from_utf8(&output.stdout).unwrap().to_string();

	if status != Status::Enter {
		return (stdout, status);
	}
    
    // Check for custom entry
    if &stdout[0..2] == "-1" {
    	status = Status::Custom;
    }
    
    // Remove index prefix (format "i - s")
    while ! stdout.starts_with('-') {
    	stdout.remove(0);
    }
    stdout.remove(0);
    stdout.remove(0);
    
    if stdout.ends_with("\n") {
    	stdout.pop();
    }
    
    (stdout, status)
}
/*
let cat_cmd = Command::new("cat").arg(input_file).stdout(Stdio::piped()).spawn().unwrap();
let rofi_cmd = Command::new("rofi").arg("-dmenu").arg("-icons").arg("-p").arg(prompt).stdin(Stdio::from(cat_cmd.stdout.unwrap())).stdout(Stdio::piped()).spawn().unwrap();
let output = rofi_cmd.wait_with_output().unwrap();
println!("{:?}", output);
*/
