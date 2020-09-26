-- Only allow symbols available in all Lua versions
std = "min"

include_files = {
    "*.lua",            -- libraries
    "widgets/*.lua",    -- officially supported widget types
}

-- Warnings to be ignored
ignore = {
    "614" -- Trailing whitespace in a comment.
}

-- Not enforced, but preferable
max_code_line_length = 80