# playlist-metadata

This is a script that creates an M3U playlist where every file of the playlist is preceded by a line including its file MD5 hash and file magic.

This allows this playlist to be processed later to check files integrity.

Even when MD5 is no longer considered safe for encryption purposes, it was chosen anyway because it is fast and it is safe enough for this purpose.

## Playlist generation

Playlist is currently generated using `playlist.sh` script, but a move to Python is planned.

This script does not allow any parameter other than the files that will become part of the playlist. It prints generated playlist to `stdout` and MD5 sum generation progress to `stderr`.

Sample usage:

```
\# genplaylist.sh "Episode 1.mp4" "Episode 2.mp4" "Episode 3.mp4" > playlist.m3u
Episode 1.mp4:  151MiB 0:00:01 [94,9MiB/s] [=================>] 100%
Episode 2.mp4:  150MiB 0:00:02 [68,3MiB/s] [=================>] 100%
Episode 3.mp4:  156MiB 0:00:01 [84,6MiB/s] [=================>] 100%
```

More files can be later added to the playlist by just appending them:

```
\# genplaylist.sh "Episode 4.mp4" >> playlist.m3u
Episode 4.mp4:  155MiB 0:00:01 [  82MiB/s] [=================>] 100%
```

## Playlist verification

A playlist generated by this script can be taken as parameter and all files contained in this playlist will be checked.

This is performed by calling `playlist-metadata` script using `-c` flag.

An optional `-v` parameter is allowed to show percentage progress while checking MD5 sum. Otherwise, only result will be print for each file.

Sample usage:

```
\# playlist-metadata -c playlist.m3u
Episode 1.mp4: OK
Episode 2.mp4: OK
Episode 3.mp4: File has no checksum
Episode 4.mp4: File not found
Episode 5.mp4: OK
Episode 6.mp4: Size differs
Episode 7.mp4: Sum differs
```

* Files `Episode 1.mp4`, `Episode 2.mp4` and `Episode 5.mp4` are OK.
* File `Episode 3.mp4` has no metadata in playlist. I.e., it is missing a line with the following format: # \<hash\> \<size\> \<magic\>
* File `Episode 4.mp4` is missing.
* File `Episode 6.mp4` has a different size than the one stored in playlist.
* File `Episode 7.mp4` has the same size as the one stored in playlist, but its MD5 sum differs.