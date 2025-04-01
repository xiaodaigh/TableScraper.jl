module TableScraper

import Gumbo
using Cascadia: @sel_str, nodeText
import HTTP

export scrape_tables

include("Tables.jl")


"""
    scrape_tables(url)
    scrape_tables(url, cell_transform[=nodeText])
    scrape_tables(url, cell_transform[=nodeText], header_transform[=nodeText])

This function will scrape `url` for any WELL-FORMED tables wrapped in `<table>` tags and return
them in a vector.

# Arguments

    - `url`: The URL to look for tables
    - `cell_transform`: By default, each of the table cells wrapped in `<td>` is transformed by
        the callable (i.e. `Function` or type definition) `cell_transform`. The default
        `cell_transform` is `Cascadia.nodeText` which extracts the node's text. You may wish to use
        `identity` to extract just the cell as a `Gumbo.HTMLNode` type for more advanced processing,
        e.g. `scrape_tables(url, identity)`
    - `header_transform`: By default, each of the table header wrapped in `<th>` is transformed by
        the callable (i.e. `Function` or type definition) `header_transform`. The default
        `header_transform` is `Cascadia.nodeText` which extracts the node's text. You may wish to
        use `identity` to extract just the cell as a `Gumbo.HTMLNode` type for more advanced
        processing, e.g. `scrape_tables(url, identity, identity)`

# Return

    `Vector{TableScraper.Table}`

The `TableScraper.Table` is a Tables.jl-compatible row-accessible type. So you can convert it to
another Tables.jl compatible type if you wish e.g. `DataFrame.(scrape_tables(url))` will return a
vector of `DataFrame`s
"""
function scrape_tables(url, args...)::Vector{Table}
    response::HTTP.Messages.Response =
        try
            HTTP.get(url)
        catch e
            println("Error when attempting to get $url. Make you are connected to the internet and the URL is accessible")
            raise(e)
        end

    # the body is the html content
    return scrape_tables(Gumbo.parsehtml(String(response.body)), args...)
end

function scrape_tables(parsed_html::Gumbo.HTMLDocument, args...)::Vector{Table}
    # look for tables in the parsed_html
    return [scrape_table(table_elem, args...) for table_elem in eachmatch(sel"table", parsed_html.root)]
end

function scrape_table(table_elem::Gumbo.HTMLElement{:table}, cell_transform=nodeText, header_transform=nodeText)::Table
    header = []
    for header1 in eachmatch(sel"tr th", table_elem)
        # check the header span
        # you are on your own if you don't use nodeText
        if (nodeText == header_transform) & haskey(header1.attributes, "colspan")
            colspan = parse(Int, header1.attributes["colspan"])
            for i in 1:colspan
                push!(header, nodeText(header1)*"$i")
            end
        else
            push!(header, header_transform(header1))
        end
    end

    result_arr = []

    # parse the tables
    # Fill dataframe with rows from the table
    for row in eachmatch(sel"tbody tr", table_elem)
        tds = cell_transform.(eachmatch(sel"td", row))
        if length(tds) > 0 # likely to be header column so don't add
            push!(result_arr, tds)
        end
    end

    return Table(result_arr, header)
end

end
