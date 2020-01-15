import os
import subprocess
import shutil
import logging as log
import re

EXIT_SUCCESS = 0
EXIT_FAILURE = -1
EXIT_SKIPPED = -10
EXIT_VIOLATION = -20


def check_dir(directory):
    # create the folder if it does not exit
    if not directory == "" and not os.path.exists(directory):
        log.warning(f"Folder {directory} does not exist! Creating...")
        directory.mkdir(parents=True, exist_ok=True)


def del_dir(directory):
    try:
        shutil.rmtree(directory)
    except OSError as e:
        log.warning("%s - %s.", e.filename, e.strerror)


def copy_file(src, dst):
    if isinstance(src, list):
        for src_file in src:
            shutil.copy2(src_file, dst)
    else:
        shutil.copy2(src, dst)


def move_file(src, dst):
    src = str(src)
    dst = str(dst)
    if isinstance(src, list):
        for src_file in src:
            src.move(src_file, dst)
    else:
        shutil.move(src, dst)


def convert(text):
    return int(text) if text.isdigit() else text.lower()


def alphanum_key(key):
    key = str(key)
    return [convert(c)
            for c in re.split('([0-9]+)', key)]


def natural_sort(l):
    return sorted(l, key=alphanum_key)


def exec_process(cmd, out_file=subprocess.STDOUT):
    log.debug("Executing %s ", cmd)
    if out_file is subprocess.STDOUT:
        result = subprocess.run(
            cmd.split(), stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        if result.stdout:
            log.debug("Process output: %s", result.stdout.decode("utf-8"))
        if result.returncode != 0:
            log.error("BEGIN " + 40 * "#")
            log.error("Failed while executing:\n%s\n", cmd)
            log.error("Output:\n%s", result.stderr.decode("utf-8"))
            log.error("END " + 40 * "#")
        return result
    err = out_file + ".err"
    out = out_file + ".out"
    with open(out, "w+") as f_out, open(err, "w+") as f_err:
        return subprocess.run(cmd.split(), stdout=f_out, stderr=f_err)
