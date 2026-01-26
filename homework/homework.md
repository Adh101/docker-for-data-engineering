# Module 1 Homework: Docker & SQL

## Question 1. Understanding Docker images

Run docker with the `python:3.13` image. Use an entrypoint `bash` to interact with the container.

What's the version of `pip` in the image?

- 25.3
- 24.3.1
- 24.2.1
- 23.3.1

### Solution:
To run the docker container with 'python:3.13' image:
`docker run -t --rm --entrypoint=bash python:3.13`

To check the `pip` version:
`pip --version`

