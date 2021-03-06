# TableScraper.jl

In this package there is only one function

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
