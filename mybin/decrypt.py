#! /bin/python2

GPG = "gpg2"
OPTIONS = " "
OPTIONS += "--quiet "
OPTIONS += "--for-your-eyes-only "
OPTIONS += "--no-tty "
OPTIONS += "--decrypt "

from subprocess import check_output

def decrypt(fpath):
    return check_output(GPG + OPTIONS + fpath, shell=True).strip("\n")

