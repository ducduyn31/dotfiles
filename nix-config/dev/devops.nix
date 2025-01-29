{ pkgs, ... }:
pkgs.mkShell {
  buildInputs = [ pkgs.terraform pkgs.terragrunt pkgs.kubectl pkgs.k9s pkgs.stern pkgs.kubectx pkgs.tflint pkgs.podman ];
  shellHook = ''
    echo "
    Welcome to the Devops environment!
    You have access to the following tools:
    - terraform: $(terraform --version | grep 'Terraform v')
    - terragrunt: $(terragrunt --version)
    - kubectl: $(kubectl version --client | grep 'Client Version')
    - tflint: $(tflint --version | grep 'TFLint')
    - and more!

    Default shell is bash. To switch to zsh, run 'zsh'.
    "
  '';
}
