{...}: {
  programs.lazygit = {
    enable = true;
    settings = {
      customCommands = [
        {
          key = "#";
          description = "gh stack";
          commandMenu = [
            {
              key = "v";
              context = "global";
              description = "View stack";
              command = "gh stack view";
              output = "terminal";
            }
            {
              key = "i";
              context = "global";
              description = "Init stack";
              command = "gh stack init {{.Form.Branch}}";
              loadingText = "Initializing stack";
              prompts = [
                {
                  type = "input";
                  title = "Branch name";
                  key = "Branch";
                }
              ];
            }
            {
              key = "a";
              context = "global";
              description = "Add branch to stack";
              command = "gh stack add {{.Form.Branch}}";
              loadingText = "Adding branch";
              output = "log";
              prompts = [
                {
                  type = "input";
                  title = "New branch name";
                  key = "Branch";
                }
              ];
            }
            {
              key = "c";
              context = "localBranches";
              description = "Checkout branch into stack";
              command = "gh stack checkout {{.SelectedLocalBranch.Name}}";
              loadingText = "Checking out";
              output = "log";
            }
            {
              key = "p";
              context = "global";
              description = "Push stack";
              command = "gh stack push";
              loadingText = "Pushing stack";
              output = "log";
            }
            {
              key = "s";
              context = "global";
              description = "Submit stack (create/update PRs)";
              command = "gh stack submit --auto --open";
              loadingText = "Submitting stack";
              output = "log";
            }
            {
              key = "y";
              context = "global";
              description = "Sync stack (fetch, rebase, push, prune)";
              command = "gh stack sync --prune";
              loadingText = "Syncing stack";
              output = "log";
            }
            {
              key = "r";
              context = "global";
              description = "Rebase stack";
              command = "gh stack rebase";
              loadingText = "Rebasing stack";
              output = "log";
            }
            {
              key = "k";
              context = "global";
              description = "Move up the stack";
              command = "gh stack up";
              output = "log";
            }
            {
              key = "j";
              context = "global";
              description = "Move down the stack";
              command = "gh stack down";
              output = "log";
            }
            {
              key = "m";
              context = "global";
              description = "Merge stack";
              command = "gh stack merge --yes";
              loadingText = "Merging stack";
              output = "log";
              prompts = [
                {
                  type = "confirm";
                  title = "Merge stack";
                  body = "Merge the entire current stack (bottom to top)?";
                }
              ];
            }
          ];
        }
      ];
    };
  };
}
