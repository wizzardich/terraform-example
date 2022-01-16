# Thoughts, process and notes

I already have `minikube` on my machine, so I will keep using that as my main K8S cluster for terraform exercise. I assume
`kind` would work just as well, but I'm not willing to spend time setting that up now.

As such, I will start with the simple stuff:

1. Create Docker image for `express-app`. I'll pick `node:17.3-alpine` - service is not demanding, so let it also be small.
2. Create Docker image for `flask-app`. I'll pick `pyton:3.10.1-alpine` - same reason. *Nota Bene*: I'm not going in on
   image security/being rootless/exposing ports for this does not seem to be the focus of the exercise.

## Feedback

