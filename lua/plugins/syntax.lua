local function vim2ext(t, s, ft)
    for k in string.gmatch(s, "%*%.(%w+),") do
        t[k] = ft
    end
end

local ext = {
    dockerfile = "dockerfile",
    automount = "systemd",
    mount = "systemd",
    path = "systemd",
    service = "systemd",
    socket = "systemd",
    swap = "systemd",
    target = "systemd",
    timer = "systemd",
    log = "log",
    LOG = "log",
    _log = "log",
    _LOG = "log",
    scpt = "applescript",
    applescript = "applescript",
    Caddyfile = "caddyfile",
    csv = "csv",
    tsv = "csv",
    tab = "csv",
    dat = "csv",
    mako = "mako",
    dbml = "dbml",
    lalrpop = "lalrpop",
    snippets = "snippets",
}

vim2ext(ext, "*.vert,*.tesc,*.tese,*.glsl,*.geom,*.frag,*.comp,*.rgen,*.rmiss,*.rchit,*.rahit,*.rint,*.rcall", "glsl")
vim2ext(ext, "*.vs,*.fs", "glsl")
vim2ext(ext, "*.graphql,*.graphqls,*.gql,*.prisma", "graphql")
vim2ext(ext, "*.gotmpl,helmfile*.yaml", "helm")

vim.filetype.add({
    extension = ext,
    pattern = {
        ["*%.snip"] = "vim",
        ["*%.nginx"] = "nginx",
        [".*nginx.*%.conf"] = "nginx",
        [".*nginx/.*/conf.*"] = "nginx",
        [".*/nginx/.*%.conf"] = "nginx",
        ["/srv/nginx/conf%.d/locations/.*"] = "nginx",
        ["*/playbooks/*.yml"] = "yaml.ansible",
        ["Caddyfile.*"] = "caddyfile",
        ["haproxy*.c*"] = "haproxy",
        ["*/templates/*.yaml"] = "helm",
        ["*/templates/*.tpl"] = "helm",
        ["*/helm/*.yaml"] = "helm",
    },
})

return {
    { "pearofducks/ansible-vim", ft = "yaml.ansible" },
    { "mityu/vim-applescript", ft = "applescript" },
    { "isobit/vim-caddyfile", ft = "caddyfile" },
    {
        "chrisbra/csv.vim",
        ft = "csv",
        init = function()
            vim.g.csv_no_progress = 1
            vim.g.csv_strict_columns = 1
            vim.g.csv_start = 1
            vim.g.csv_end = 100
            vim.g.csv_nomap_up = 1
            vim.g.csv_nomap_down = 1
            vim.g.csv_default_delim = ";"
        end,
    },
    { "tikhomirov/vim-glsl", ft = "glsl" },
    { "jparise/vim-graphql", ft = "graphql" },
    { "CH-DanReif/haproxy.vim", ft = "haproxy" },
    { "towolf/vim-helm", ft = "helm" },
    { "sophacles/vim-bundle-mako", ft = "mako" },
    { "chr4/nginx.vim", ft = "nginx" },
    { "marshallward/vim-restructuredtext", ft = "rst" },
    { "vim-scripts/svg.vim", ft = "svg" },
    { "wgwoods/vim-systemd-syntax", ft = "systemd" },
    { "amadeus/vim-xml", ft = "xml" },
    { "MTDL9/vim-log-highlighting", ft = "log" },
    { "jidn/vim-dbml", ft = "dbml" },
    {
        "L3MON4D3/LuaSnip",
        build = "make install_jsregexp",
        ft = "snippets",
    },
}
