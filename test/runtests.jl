using TableScraper
using DataFrames
using Test

@testset "TableScraper.jl" begin
    table = scrape_tables("https://www.agenas.gov.it/covid19/web/index.php?r=site%2Fprovvedimento&q=010")[1] |> DataFrame;

    @test nrow(table) > 0
end

@testset "TableScraper.jl goratings" begin
    table = scrape_tables("https://goratings.org")[2] |> DataFrame;
    @test nrow(table) > 0
end
