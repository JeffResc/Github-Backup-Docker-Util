# Github-Backup-Docker-Util
Backup your entire GitHub account to a remote location using Docker

## Utilities used
- [rclone](https://rclone.org/)
- [python-github-backup](https://github.com/josegonzalez/python-github-backup)

# Setting Up
- First, get a hold of your `rclone.conf` file. You can do this by running `rclone config` (in this container or not) and then finding the file at `~/.config/rclone/rclone.conf`. Once you have that file, be sure to mount it to `~/.config/rclone/rclone.conf` in the container using a volume. Feel free to store this anywhere on the host machine in a safe, but accessible location.
- Modify the `.env` file by using `.env.sample` as your template. Either use the `.env` file [and enable it when running the container using --env-file](https://www.techrepublic.com/article/how-to-use-docker-env-file/) or [the -e flag](https://docs.docker.com/engine/reference/commandline/run/).