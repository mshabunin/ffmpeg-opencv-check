### Instruction

1. Preparations:
    - Edit `.env` to match system configuration
    - Add a video file to the `scripts` directory
    - Change `VID` variable in the `scripts/build.sh` to point to the video file
    - Run `./scripts/init.sh` to create `workdir` and `cache` directories
2. Run `docker-compose up`
3. Edit `scripts/build.sh` as necessary
4. Go to 2

### Cleanup

Remove `workdir` with all sources and build results: `./scripts/cleanup.sh`
