{ pkgs, ... }:
let
  gdk = pkgs.google-cloud-sdk.withExtraComponents
    (with pkgs.google-cloud-sdk.components; [ gke-gcloud-auth-plugin ]);
in pkgs.mkShell {
  buildInputs = with pkgs; [
    docker-compose
    pulumi
    pulumiPackages.pulumi-nodejs
    ssm-session-manager-plugin
    awscli2
    azure-cli
    terraform
    kubectl
    k9s
    stern
    kubectx
    tflint
    gdk
  ];
  shellHook = ''
    echo "
    Welcome to the Devops environment!
    You have access to the following tools:
    - terraform: $(terraform --version | grep 'Terraform v')
    - terragrunt: $(terragrunt --version)
    - kubectl: $(kubectl version --client | grep 'Client Version')
    - tflint: $(tflint --version | grep 'TFLint')
    - gcloud: $(gcloud --version | head -n 1)
    - and more!

    Default shell is bash. To switch to zsh, run 'zsh'.
    "
  '';
}
