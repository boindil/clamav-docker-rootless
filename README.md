# clamav-docker-rootless

This solution aims at providing a rootless docker image which can be used with kubernetes at ease.

This comes without any warranties as is.

This is working with clamav 1.0.1

## Notes
There are still a few things that could be optimized
- automatic restart of services in case one fails
- improve error handling - I had a cluster with networking problems and freshclam did not seem too happy about it. It locked up the whole container.

## Hints
- I had problems accessing the logfiles in a kubernetes environment with deployments and shared space. This tries to avoid that by checking the logfile prior to attemting to write it. I had to provide a C binary since the actual lock is not held in the starting container but in the one that is still running.
- a sample kubernetes deployment example can be found inside the examples folder
- - the first initcontainer makes sure all folders are present, depending on your storage solution this might not be necessary.
- this is split into seperate container images, since I did not see a practical way of modifying the config otherwise. I case clamav provides a stable rootless image at some point in the future, the config initialization will still work fine
- your mileage may vary - adjust to your own needs

## Further development
- I do not plan to put heavy work into this, but this might help someone
- There might be a few optimizations coming, but no ETA and no promises!
- Feel free to create PRs and I will look into those
