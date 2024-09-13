## Navajo OSGi Distribution

(force rebuild: 2024-09-13)

If you are reading this, you must be interested in building target platforms for Eclipse or base images!

Great.


First of all, I use CircleCI for all of this. It adds a consistency for builds that is hard to match on your own machine.
You can build it on your own machine if you want (the .circleci/config.yml basically specifies bash commands).

You can check the builds of this repository here:

https://circleci.com/gh/Dexels/dexels-base/tree/master


The build process works like this:

- We run an ant file (which uses by default the build.xml file in the root folder), the ant file creates a maven pom file using the maven coordinates from the *.cfg files. The ant build uses a few custom Ant tasks, inside the com.dexels.navajo.dev.ant project within Navajo. I realize that this is a bit circular. If this offends you, you can extract this project into its own repository, I don't think there are any dependencies on the rest of Navajo

- Then it runs maven to resolve those files.
- For the base container, it will include all maven coordinates in 'core.cfg' these are the basics that should be on every installation
- For the target platform it will include all these files: oao.cfg,sendrato.cfg,appstore.cfg,targetplatform.cfg,core.cfg


The target platform is way more inclusive: It is intended to give a set of bundles that you might need.

The target platform will be uploaded to the repo.dexels.com
The base container will be uploaded to dockerhub: https://hub.docker.com/r/dexels/dexels-base/tags

The last digit of (both the target platform and the container build) is the circleci job number.

So the high level workflow is:
- Check if this repo is clean and up to date.
- Check if the last build in circleci succeeded. If not, troubleshoot and fix that first.
- Update the config files to reflect the changes you need
- Commit and push
- Check circleci.

After that, update the target platform in navajo (and other projects) to point to the new build.
Or, for runtime, update the kubernetes image definitions.


### Troubleshooting
The nexus maven repository runs here: https://repo.dexels.com
The eclipse p2 repository runs here: https://p2.dexels.com (you can check if it works be checking if this url returns something: https://p2.dexels.com/eclipse/equinox4.9/content.xml)

If either of those fail, it can't upload the artifacts, and the builds will fail.
If the repo.dexels.com gives a 502 Bad Gateway, the nexus container has failed (but the NGINX load balancer is still up). 
Sometimes it runs out of memory (I guess) or even disk space. Target platforms get pretty big and you will run out of disk space if you don't clean up old ones.

SSH into that machine (I suppose you'll have access).
Restart with a 'docker stop nexus3' and a 'docker start nexus3', if necessary escalate to docker kill, 'service docker restart' or reboot the whole thing.
Bear in mind that starting nexus (especially after a dirty shutdown) can take a few minutes to start. Check the logs if unsure.

Will create a target platform (for building, based on the configuration files)
Will create a base openjdk11 + felix 6.0.x based base container.

Checking the config.yml file in the .circleci folder is a good place to start figuring out how this works.
`ant -Dupload=true -Ddocker=true`

## Updating the Navajo target platform
Once the circleci has completed, that means that now there is a p2 repository on the repo.dexels.com machine which we can use..
