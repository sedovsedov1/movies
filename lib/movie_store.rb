

require 'yaml/store'                           # подключить библиотеку работы с store

class MovieStore                               # определить класс MovieStore
	                                             # есть методы: find, all, save

	def initialize(file_name)                    # инициализация класса
		@store = YAML::Store.new(file_name)        # @store = новый стандартный store из YAML = файл movie.yml
	end

	def find(id)                                 # метод find (поиск) по id
		@store.transaction do                      # делаем защищенную транзакцию при работе
			@store[id]                               # возвращаем конкретную запись по id (если есть)
		end
	end

	def all                                      # метод all (все данные)
		@store.transaction do                      # делаем защищенную транзакцию при работе
			@store.roots.map { |id| @store[id] }     # проходим по всему массиву данных и возвращаем id записей
		end
	end

	def save(movie)                              # метод save (сохранить) фильм
		@store.transaction do                      # делаем защищенную транзакцию при работе
			unless movie.id                          # если у фильма нет id, то он еще не в базе
				highest_id = @store.roots.max || 0     # подбираем для фильма индекс = либо 0, либо максимальный
				movie.id = highest_id + 1              # вернее, следующий после максимального
			end
			@store[movie.id] = movie                 # кладем в базу фильм по его индексу (происходит запись в файл)
		end
	end

end