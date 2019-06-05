## Navajo OSGi Distribution

Will create a target platform (for building, based on the configuration files)
Will create a base openjdk11 + felix 6.0.x based base container.

Checking the config.yml file in the .circleci folder is a good place to start figuring out how this works.
`ant -Dupload=true -Ddocker=true`
