use std::{
    env::args,
    fs::OpenOptions,
    io::{Read, Seek, SeekFrom, Write},
};

use anyhow::{Context, Result};

/// Prepends the contents of a given file with a newline IF it already starts with a newline.
///
/// Used to add an extra newline to the start of the Git commit message template.
fn main() -> Result<()> {
    let file_path = args().nth(1).context(
        "Expected file path argument\
        \n\n\
        Usage: prepend-newline <filepath>",
    )?;

    let mut file = OpenOptions::new()
        .read(true)
        .write(true)
        .open(file_path)
        .context("Failed to open file")?;

    const DEFAULT_COMMIT_MESSAGE_FILE_SIZE: usize = 437;
    let mut contents = String::with_capacity(DEFAULT_COMMIT_MESSAGE_FILE_SIZE + 1); // +1 for the newline we're prepending

    file.read_to_string(&mut contents)
        .context("Failed to read file")?;

    if contents.starts_with('\n') {
        contents.insert(0, '\n');

        file.seek(SeekFrom::Start(0))
            .context("Failed to seek to beginning of file")?;
        file.write_all(contents.as_bytes())
            .context("Failed to write to file")?;
    }

    Ok(())
}
