# Thoughts, process and notes

I already have `minikube` on my machine, so I will keep using that as my main K8S cluster for terraform exercise. I assume
`kind` would work just as well, but I'm not willing to spend time setting that up now.

As such, I will start with the simple stuff:

1. Create Docker image for `express-app`. I'll pick `node:17.3-alpine` - service is not demanding, so let it also be small.
2. Create Docker image for `flask-app`. I'll pick `pyton:3.10.1-alpine` - same reason.

   *Nota Bene*:

    - I'm not going in on image security/being rootless/exposing ports for this does not seem to be the focus of the
      exercise.
    - I'm also not inbuilding the env vars; these seem to be a good representation of configuration/env, so let's leave
      them be and set them from the outside. That's also the assignment demand.

3. I'll push the images into the `minikube`. Well, rather, I'll directly build them inside. `eval $(minikube docker-env)`
   allows to retarget my docker CLI to use the docker daemon within `minikube`, so all the images further built will be
   available inside.

   ```sh
   eval $(minikube docker-env)
   cd ../flask-app
   docker build --tag flask-app:latest .
   cd ../express-app
   docker build --tag express-app:latest .
   eval $(minikube docker-env -u)
   ```

4. When creating a terraform module, it is quite important (as per [`minikube` documentation][[minikube-docker-env]) to
   set the image pull policy to something other then the default "Always".

## Feedback


[minikube-docker-env]: https://minikube.sigs.k8s.io/docs/handbook/pushing/#1-pushing-directly-to-the-in-cluster-docker-daemon-docker-env