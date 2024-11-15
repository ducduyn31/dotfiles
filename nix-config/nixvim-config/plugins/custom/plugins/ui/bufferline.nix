{ ... }: {
  plugings.bufferline = {
    enable = true;
    keymaps = [
      {
        mode = "n";
        key = "<Tab>";
        action = "<Cmd>BufferLineCycleNext<CR>";
        options = { desc = "Cycle to the next buffer"; };
      }
      {
        mode = "n";
        key = "<S-Tab>";
        action = "<Cmd>BufferLineCyclePrev<CR>";
        options = { desc = "Cycle to the previous buffer"; };
      }
      {
        mode = "n";
        key = "<S-l>";
        action = "<Cmd>BufferLineCycleNext<CR>";
        options = { desc = "Cycle to the next buffer"; };
      }
      {
        mode = "n";
        key = "<S-h>";
        action = "<Cmd>BufferLineCyclePrev<CR>";
        options = { desc = "Cycle to the previous buffer"; };
      }
      {
        mode = "n";
        key = "<leader>bd";
        action = "<Cmd>bdelete<CR>";
        options = { desc = "Delete buffer"; };
      }
      {
        mode = "n";
        key = "<leader>bp";
        action = "<Cmd>bprevious<CR>";
        options = { desc = "Previous buffer"; };
      }
      {
        mode = "n";
        key = "<leader>bb";
        action = "<Cmd>e #<CR>";
        options = { desc = "Switch to other buffer"; };
      }
      {
        mode = "n";
        key = "<leader>br";
        action = "<Cmd>BufferLineCloseRight<CR>";
        options = { desc = "Close buffer to the right"; };
      }
      {
        mode = "n";
        key = "<leader>bl";
        action = "<Cmd>BufferLineCloseLeft<CR>";
        options = { desc = "Close buffer to the left"; };
      }
      {
        mode = "n";
        key = "<leader>bo";
        action = "<Cmd>BufferLineCloseOthers<CR>";
        options = { desc = "Close other buffers"; };
      }
      {
        mode = "n";
        key = "<leader>bp";
        action = "<Cmd>BufferLineTogglePin<CR>";
        options = { desc = "Toggle buffer pin"; };
      }
      {
        mode = "n";
        key = "<leader>bP";
        action = "<Cmd>BufferLineGroupClose ungrouped<CR>";
        options = { desc = "Close non-pinned buffers"; };
      }
    ];
  };
}
