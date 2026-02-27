Also this is for manual deploy but we can actual leverage the github actions runner for this too as well basically:

1. Once the repository is prepared, meaning it has a dockerfile and docker compose(optional) if its a stack then we need to include a workflow for gh actions
2. You will need to do this twice I guess since the runner doesnt appear yet on the actions once you have a workflow. usually it will go like this
```yml
name: Deploy to Server
on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: self-hosted
    steps:
      - name: Checkout Code
        uses: actions/checkout@v4

      - name: Deploy App Stack
        run: |
          # Use -f to target your example file
          # 'down' ensures names are released before 'up' starts
          docker compose -f docker-compose.example.yml down --remove-orphans

          # Now start the fresh build
          docker compose -f docker-compose.example.yml up --build -d

          # Clean up space
          docker image prune -fp
```
This basically tells the gh to hey use the self-hosted(this is the runner) and then the run is where the docker compose or docker command depends on the repository will be exected on where the runner is running, in my case its on my ubuntu server which is by the way can't be access via IP since i am behind CGNAT so we just basically uses the github to bridge the connection of my server to the wokflow.  

3. One thing that is needed here is make sure it works first. meaning you can test deploy on the server via this script and then if it worked like 100% well maybe add jest later on the projects then we can do the this and well trigger the test as well lmao


This is basically a low budget CI / CD it's not the whole thing but it's the most basic form I say.
