use std::{
    fs::OpenOptions,
    io::{Read, Seek, SeekFrom, Write},
};

use anyhow::{Context, Result};
use clap::Parser;
use url::form_urlencoded;

/// Reads the file at the given path, URL-encodes it, and writes it back.
#[derive(Parser, Debug)]
#[command(about)]
struct Args {
    #[arg()]
    file_path: String,
}

fn main() -> Result<()> {
    let args = Args::parse();

    let mut file = OpenOptions::new()
        .read(true)
        .write(true)
        .open(args.file_path)
        .context("Failed to open file")?;

    let mut contents = String::new();
    file.read_to_string(&mut contents)
        .context("Failed to read file")?;

    let url_encoded = form_urlencoded::byte_serialize(contents.as_bytes()).collect::<String>();

    file.seek(SeekFrom::Start(0))
        .context("Failed to seek to beginning of file")?;
    file.write_all(url_encoded.as_bytes())
        .context("Failed to write to file")?;

    Ok(())
}
