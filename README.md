# TableScraper.jl

In this package there is only one function

`scrape_tables(url)`

which lets you scrape for tables wrapped in `<table>` tag and return them in a [Tables.jl](https://github.com/JuliaData/Tables.jl) compatible row-table.

By default the function uses `Cascadia.nodeText` to extract the text from each `<td>` node.

However, if you wish to extract more than the text node you may use

```
scrape_tables(url, identity)
```

to keep the cells as `Gumbo.HTMLNode`s and do more advanced extraction.

Also, you can put any call into the `cell_transform` argument to do custome transformation of the `<td>` nodes before returning.

E.g.

```
scrape_tables(url, cell_transform)
```
