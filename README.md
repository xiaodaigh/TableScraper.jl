# TableScraper.jl

In this package, there is only one function

```
scrape_tables(url)
```

which lets you scrape for tables wrapped in `<table>` tags and return them in a vector of [Tables.jl](https://github.com/JuliaData/Tables.jl) compatible row-tables.

By default the function uses `Cascadia.nodeText` to extract the text from each `<td>` node.

However, if you wish to extract more than the text node you may want to use

```
scrape_tables(url, identity)
```

to keep the cells as `Gumbo.HTMLNode`s and do more advanced extraction.

Also, you can put any callable into the `cell_transform` argument to do custom transformation of the `<td>` nodes before returning.

E.g.

```
scrape_tables(url, cell_transform)
```

## Video Tutorial

[![Video: Introducing TableScraper.jl - an easy way to scrape WELL-FORMED tables in Julia](https://img.youtube.com/vi/Bi1faYTkIGM/0.jpg)](https://www.youtube.com/watch?v=Bi1faYTkIGM)

## Internals

The returned table is TableScraper.Table which is defined as below

```
struct Table
    rows
    columnnames
end
```

So if you need to scrape some malformed tables, you can directly manipulate the data as in the below example

```
url = "https://www.ssa.gov/oact/NOTES/as120/images/LD_fig5.html"
tbl = only(TableScraper.scrape_tables(url, strip ∘ nodeText))

rows = tbl.rows[3:end]
header = tbl.rows[2]

df = DataFrame(TableScraper.Table(rows, header))
```


