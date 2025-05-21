# === 1. Подключение необходимых библиотек ===
library(readr)      # Для загрузки данных
library(dplyr)      # Для обработки данных
library(forecast)   # Для моделей ARIMA / ARIMAX
library(ggplot2)    # Для визуализации прогнозов
library(lubridate)  # Для работы с датами

# === 2. Загрузка и подготовка данных ===
# Загрузка CSV-файла с данными по акциям ПАО "Магнит"
stock_data <- read_delim("/home/moriitch/GitHub/ARIMAX-Stock-Forecast/MGNT.csv",
                         delim = ";", col_types = cols())

# Переименование столбцов и преобразование типов
stock_data <- stock_data %>%
  rename(
    TICKER = `<TICKER>`,
    PER    = `<PER>`,
    DATE   = `<DATE>`,
    TIME   = `<TIME>`,
    OPEN   = `<OPEN>`,
    HIGH   = `<HIGH>`,
    LOW    = `<LOW>`,
    CLOSE  = `<CLOSE>`,
    VOL    = `<VOL>`
  ) %>%
  mutate(
    DATE  = as.Date(as.character(DATE), format = "%Y%m%d"),
    OPEN  = as.numeric(OPEN),
    HIGH  = as.numeric(HIGH),
    LOW   = as.numeric(LOW),
    CLOSE = as.numeric(CLOSE),
    VOL   = as.numeric(VOL)
  ) %>%
  arrange(DATE) %>%     # Сортировка по дате
  na.omit()             # Удаление пропусков

# === 3. Формирование временного ряда и регрессоров ===
# Временной ряд по ценам закрытия
close_ts <- ts(stock_data$CLOSE, frequency = 1)

# Матрица регрессоров для ARIMAX (OPEN, HIGH, LOW, VOL)
xreg_matrix <- stock_data %>%
  select(OPEN, HIGH, LOW, VOL) %>%
  as.matrix()

# === 4. Разделение на обучающую и тестовую выборки (90% / 10%) ===
n_total     <- nrow(stock_data)
train_size  <- floor(0.9 * n_total)

# Разделение временного ряда
train_close <- window(close_ts, end = train_size)
test_close  <- window(close_ts, start = train_size + 1)

# Разделение регрессоров
train_xreg <- xreg_matrix[1:train_size, ]
test_xreg  <- xreg_matrix[(train_size + 1):n_total, ]

# === 5. Обучение и прогнозирование: модель ARIMA ===
cat("\n==== ARIMA: только CLOSE ====\n")
arima_model <- auto.arima(train_close)
arima_forecast <- forecast(arima_model, h = length(test_close))
arima_accuracy <- accuracy(arima_forecast, test_close)
print(arima_accuracy)

# === 6. Обучение и прогнозирование: модель ARIMAX ===
cat("\n==== ARIMAX: регрессоры OPEN + HIGH + LOW + VOL ====\n")
arimax_model <- auto.arima(train_close, xreg = train_xreg)
arimax_forecast <- forecast(arimax_model, h = length(test_close), xreg = test_xreg)
arimax_accuracy <- accuracy(arimax_forecast, test_close)
print(arimax_accuracy)

# === 7. Визуализация прогнозов ===
# Прогноз ARIMA
ggplot() +
  autolayer(arima_forecast, series = "Прогноз ARIMA") +
  autolayer(test_close, series = "Фактические", color = "black") +
  labs(
    title = "Прогноз цен закрытия: ARIMA",
    x = "Наблюдение",
    y = "Цена закрытия"
  ) +
  theme_minimal()

# Прогноз ARIMAX
ggplot() +
  autolayer(arimax_forecast, series = "Прогноз ARIMAX") +
  autolayer(test_close, series = "Фактические", color = "black") +
  labs(
    title = "Прогноз цен закрытия: ARIMAX с OHLCV",
    x = "Наблюдение",
    y = "Цена закрытия"
  ) +
  theme_minimal()

# =======================
autoplot(forecast_arima) +
  autolayer(test_close, series = "Фактические") +
  ggtitle("Прогноз ARIMA: только CLOSE") +
  xlab("Наблюдение") + ylab("Цена закрытия") +
  theme_minimal()

autoplot(forecast_arimax) +
  autolayer(test_close, series = "Фактические") +
  ggtitle("Прогноз ARIMAX: CLOSE ~ OPEN + HIGH + LOW + VOL") +
  xlab("Наблюдение") + ylab("Цена закрытия") +
  theme_minimal()



# Модель ARIMAX значительно превосходит ARIMA 
# по всем метрикам на тестовой выборке.

# Это означает, что включение дополнительных признаков (OPEN, HIGH, LOW, VOL) 
# действительно позволило уточнить модель.

# Особенно показательны улучшения в MAPE, RMSE и Theil’s U.