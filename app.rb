

require 'sinatra'                          # подключаем библиотеку Sinatra
require 'movie'                            # подключаем библиотеку movie
require 'movie_store'                      # подключаем библиотеку movie_store

store = MovieStore.new('movies.yml')       # store = новый объект класса MovieStore = файл movie.yml
                                           # есть методы: find, all, save

get('/movies') do                          # обработка /movies (корень сайта)
	@movies = store.all                      # @movies = прочитать все из store (массив данных)
	erb :index                               # вызвать просмотрщик index (корень сайта)
end

get('/movies/new') do                      # обработка /movies/new (создание новой записи)
	erb :new                                 # вызвать просмотрщик new (создать новую запись)
end

post('/movies/create') do                  # обработка /movies/create (прислали данные) 
	@movie = Movie.new                       # @movie = создали новый фильм
	@movie.title = params['title']           # записали присланный параметр
	@movie.director = params['director']     # записали присланный параметр
	@movie.year = params['year']             # записали присланный параметр
	store.save(@movie)                       # сохранили фильм в store 
	redirect '/movies/new'                   # редирект на создание новой записи
end

get('/movies/:id') do                      # обработка /movies/:id (конкретный фильм по id)
	id = params['id'].to_i                   # id = параметр, который был в строке, конвертировать в число
	@movie = store.find(id)                  # @movie = найти фильм из store по его id
	erb :show                                # вызвать просмотрщик show (полная информация о фильме)
end
