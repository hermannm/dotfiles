use std::{
    env::{args, current_dir, set_current_dir},
    ffi::OsStr,
    fs::remove_file,
    process::{Command, Stdio},
};

use anyhow::{bail, Context, Result};
use tracing::info;
use walkdir::WalkDir;

/** Reinitializes all Git hooks in repositories under the given root path. */
fn main() -> Result<()> {
    tracing_subscriber::fmt()
        .without_time()
        .with_target(false)
        .init();

    let root_dir = args().nth(1).context(
        "Expected root dir argument\
        \n\n\
        Usage: reinit-git-hooks <root_dir>",
    )?;

    let current_dir = current_dir().context("Failed to get current dir")?;

    for entry in WalkDir::new(root_dir).into_iter().filter_map(|e| e.ok()) {
        if !entry.file_type().is_dir() || entry.file_name() != ".git" {
            continue;
        }

        let mut path = entry.path().to_path_buf();
        path.push("hooks");

        for hook in WalkDir::new(&path).into_iter().filter_map(|e| e.ok()) {
            // We don't want to remove directories or sample hooks
            if hook.file_type().is_dir() || hook.path().extension() == Some(OsStr::new("sample")) {
                continue;
            }

            info!("Removing {}", hook.path().to_string_lossy());
            remove_file(hook.path()).context("Failed to remove file")?;
        }

        // Pops off .git/hooks from path
        path.pop();
        path.pop();

        set_current_dir(&path)
            .with_context(|| format!("Failed to change dir to '{}'", path.to_string_lossy()))?;

        info!("Reinitializing Git repository {}", path.to_string_lossy());
        let exit_status = Command::new("git")
            .arg("init")
            .stdout(Stdio::null())
            .status()
            .with_context(|| {
                format!(
                    "Failed to run 'git init' command in {}",
                    path.to_string_lossy()
                )
            })?;
        if !exit_status.success() {
            bail!(
                "Failed to reinitialize git repository in '{}'",
                path.to_string_lossy()
            );
        }

        set_current_dir(&current_dir).with_context(|| {
            format!(
                "Failed to change back to current dir '{}'",
                current_dir.to_string_lossy()
            )
        })?;
    }

    Ok(())
}
