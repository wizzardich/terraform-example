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

5. I compose terraform module pretty much according to the description given in the Hashicorp guide + documentation. One
   thing that I'm not particularly happy about so far is the setting of "FIB_ENDPOINT" value. It's a bit too long now.

6. One thing that needs to happen on the nginx ingress: rewriting of the target URL. I went with the suggestiong from
   [here][ingress-nginx-rewrite], it seemed simple enough.

7. Took me some time to realize I missed the `gunicorn` bind clue, but I figured it out. By default `gunicorn` process
   binds to `127.0.0.1` instead of `0.0.0.0`. Caused me some pain :)
   
8. I implemented an autoscaling policy, resource consumption-based. Based on the agreed duration of the task I did not
   have enough time to benchmark it, or make a more resource consuming function then the `generate_load()` one, so I do
   not have a clear understanding of how good/bad the autoscaler performs now.

## Feedback

So, all-in-all assignment is fairly well described. I appreciated the documentation links a lot, including the ones that
help the setup, though I already had most of that up and running. That said, there is a couple of missing points:

1. Define what's your policy on modifying the sources. I assumed that "no touching" is the policy implied. Might also make
   sense to ask the candidate to implement a service in the language of choice. Not the main focus, but does provide a bit
   of an insight into the thinking pattern.

2. Define the expected set of deliverables. Are dockerfiles important? Is Terraform where you want the candidate to focus?
   I understand that you probably want to estimate the full picture, but some things are still probably more important then
   some others.

3. The general description could be a bit refocused; instead of "install kubernetes resources", you probably want to say
   something like "Submit Terraform modules that will...". A set of constraints is good: tests the knowledge on ingresses,
   services, deployments, introducing containers into the cluster, debugging the containers, etc.
   
   Again, it's understandable, just could be written a bit clearer.
   
4. If a person fulfilling the assignment has some terraform experience, 3 hours are way too long. It was a lot of time even
   for me, though I managed to spend some of it messing around with changing the code and reading the docs. I guess that
   depends on the point of the exercise? If the point is taking a look at how fast a new tech can be picked up, this  might
   indeed be a decent time allotment.

[minikube-docker-env]: https://minikube.sigs.k8s.io/docs/handbook/pushing/#1-pushing-directly-to-the-in-cluster-docker-daemon-docker-env
[ingress-nginx-rewrite]: https://graphicsunplugged.com/2021/12/18/removing-url-prefixes-in-nginx-kubernetes-ingress/
