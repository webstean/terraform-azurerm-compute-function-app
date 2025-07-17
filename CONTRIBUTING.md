# Contributing

Thank you for considering contributing to this project! Your contributions help improve the quality and functionality of the module, making it more useful for everyone.
Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project

```shell
gh repo fork webstean/terraform-azurerm-compute-function-app --clone
```

2. Setup the environment.

   This project uses vscode devcontainer to provide a completly configured development environment. If you are using vscode and have the remote container extension installed, you should be asked to use the devcontainer when you open this project inside of vscode.

   If you are not using devcontainers then you will need to have `terraform`, `pre-commit`, `terraform-docs`, `tflint`, `tfsec` and `checkov` installed. 

   Most of the steps can be found in the [Dockerfile](.devcontainer/Dockerfile).

3. Create your Feature Branch

```shell
   git checkout -b amazing_feature
```

4. Commit your Changes

```shell
   git commit -m 'Added something amazing!'
```

5. Push your changes (`git push origin amazing_feature`)

```shell
   git push origin amazing_feature
```

6. Open a Pull Request

```shell
   gh pr create --base main --head amazing_feature --title "Amazing Feature" --body "Please accept this amazing feature"
```

