# servian tech challenge

<img width="1068" alt="Screenshot 2022-07-31 at 15 09 44" src="https://user-images.githubusercontent.com/22427765/182011115-6b30472a-0397-439f-b4bb-074adbc69bd4.png">

## Repository structure

``` sh
.
├── app                     # Folder containing app
|   ├── config.toml         # Config file required by the executable
|   └── TechChallengeApp    # App executable
├── infrastructure          # Folder containing terraform infrastructure code 
│   └── main.tf             # Infrastructure code
├── scripts                 # Folder containing scripts referenced by appspec.yml
|   └── serve.sh            # Script to run the app after deployment
├── .gitignore              # Good ol' gitignore
└── appspec.yml             # AWS CodeDeploy configuration file
```

## Notes
App folder is deployed to the ec2 instance on every push to master via AWS CodeDeploy.

CodeDeploy was configured manually.

Minimum of two subnets are required for the RDS subnet group even for Single-AZ deployment.
