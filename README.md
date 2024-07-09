## Docker compose and dockerfile for self hosting synapse, the maxtrix homeserver! (and sliding sync)

Make sure your `homeserver.yaml` is in `./data` (local path) and the media storage in said file is set to `/storage` (docker path).

You will have to look at the `docker-compose.yml` and set the postgres passwords in every entry in that file as well as the sliding sync secret value.

Don't forget to set the database info appropriately in the homeserver.yaml as well!

In the `Dockerfile` the commit hash can be changed to any version and it will build that version. I'll do my best to keep the hash updated to the newest release.

Don't forget to wire up the exposed synapse and sliding sync ports to the public! I recommend using something like Cloudflare tunnels (it's what I use).

## Delegation

As far as delegation goes you can essentially copy [this GitHub repo](https://github.com/dillfrescott/dill.tokyo) but put your own values in `.well-known/matrix/client` and `.well-known/matrix/server` files! Then host it using GitHub Pages! Also you can modify `index.html` to have it redirect to any site you wish! Or even get rid of it entirely! It's totally up to you!

Have fun! :)
