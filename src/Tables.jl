# implement Tables.jl's row access interface
# https://tables.juliadata.org/stable/#Implementing-the-Interface-(i.e.-becoming-a-Tables.jl-source)-1

import Tables
# import Tables: istable, rowaccess, columnaccess, rows, columnnames, getcolumn, AbstractRow
import Base: eltype, length, iterate

# a table structure local to TableScraper
struct Table
    rows
    columnnames
end

struct TableRow <: Tables.AbstractRow
    row::Int
    source::Table
end

Tables.istable(::Table)=true
Tables.rowaccess(::Table)=true
Tables.columnaccess(::Table)=true
Tables.columnnames(t::Table)=t.columnnames
Tables.rows(t::Table)=t


Base.eltype(::Table) = TableRow
Base.length(t::Table) = length(t.rows)
Base.iterate(t::Table, st = 1) = st > length(t) ? nothing : (TableRow(st, t), st+1)

function Tables.getcolumn(t::TableRow, ::Type, col::Int, nm::Symbol)
     tbl = getfield(t, :source)
    row = tbl.rows[t.row]
    row[col]
end

function Tables.getcolumn(t::TableRow, i::Int)
    tbl = getfield(t, :source)
    row_num = getfield(t, :row)
    row = tbl.rows[row_num]
    row[i]
end

function Tables.getcolumn(t::TableRow, nm::Symbol)
    tbl = getfield(t, :source)
    row_num = getfield(t, :row)
    row = tbl.rows[row_num]
    col = indexin([string(nm)], tbl.columnnames)[1]
    row[col]
end


Tables.columnnames(t::TableRow) = getfield(t, :source).columnnames