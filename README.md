# blink-cmp-cmdlinehistory

A [blink.cmp](https://github.com/saghen/blink.cmp) source for Neovim cmdline mode.

## Features

- When entering cmdline (`:` / `/` / `?`) with no keyword typed, displays command/search history as completion candidates.
- When a keyword is typed, force-inserts the keyword itself as a completion candidate, ensuring your exact input is always available for selection.

## Installation (lazy.nvim)

```lua
return {
    {
        'saghen/blink.cmp',
        dependencies = { "yaocccc/blink-cmp-cmdlinehistory" },
        version = '1.*',
        lazy = false,
        init = function()
            vim.api.nvim_create_autocmd('CmdlineEnter', {
                callback = function()
                    local type = vim.fn.getcmdtype()
                    if type == '/' or type == '?' or type == ':' then
                        vim.schedule(function()
                            if vim.fn.mode() == 'c' then require('blink.cmp').show() end
                        end)
                    end
                end,
            })
        end,
        opts = {
            -- ...
            cmdline = {
                sources = { "clhistory", "cmdline", "buffer" },
            },
            sources = {
                providers = {
                    clhistory = {
                        name = 'history',
                        module = 'cmdlinehistory',
                        score_offset = 999,
                        opts = {
                          fiexedkeyword = true, -- default
                        }
                    },
                },
            },
        },
        opts_extend = { "sources.default" },
    },
}
```

> **Tip**: The `CmdlineEnter` autocmd above automatically triggers blink.cmp when you enter `:`, `/`, or `?` mode, so history shows up immediately without needing to type anything first.

---

# blink-cmp-cmdlinehistory

[blink.cmp](https://github.com/saghen/blink.cmp) 的命令行补全源。

## 功能

- 进入命令行模式（`:` / `/` / `?`）且未输入关键字时，自动显示对应的历史记录作为补全候选。
- 输入关键字后，将关键字本身强制插入到补全候选中，确保你的精确输入始终可被选中。

## 安装 (lazy.nvim)

```lua
return {
    {
        'saghen/blink.cmp',
        dependencies = { "yaocccc/blink-cmp-cmdlinehistory" },
        version = '1.*',
        lazy = false,
        init = function()
            vim.api.nvim_create_autocmd('CmdlineEnter', {
                callback = function()
                    local type = vim.fn.getcmdtype()
                    if type == '/' or type == '?' or type == ':' then
                        vim.schedule(function()
                            if vim.fn.mode() == 'c' then require('blink.cmp').show() end
                        end)
                    end
                end,
            })
        end,
        opts = {
            -- ...
            cmdline = {
                sources = { "clhistory", "cmdline", "buffer" },
            },
            sources = {
                providers = {
                    clhistory = {
                        name = 'history',
                        module = 'cmdlinehistory',
                        score_offset = 999,
                        opts = {
                          fiexedkeyword = true, -- 默认，true时会在第一项插入你输入的关键字，false时关闭
                        }
                    },
                },
            },
        },
        opts_extend = { "sources.default" },
    },
}
```

> **提示**：上面的 `CmdlineEnter` autocmd 会在进入 `:`、`/`、`?` 模式时自动触发 blink.cmp，无需手动输入即可立即显示历史记录。
