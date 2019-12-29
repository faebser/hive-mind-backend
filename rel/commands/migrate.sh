#!/bin/sh

release_ctl eval --mfa "HiveBackend.ReleaseTasks.migrate/1" --argv -- "$@"