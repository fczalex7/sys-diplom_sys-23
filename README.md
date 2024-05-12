# Дипломная работа по профессии «Системный администратор»
## Фролов Адександр SYS-23
## Задание к дипломной работе
### Дипломная работа по профессии «Системный администратор»
Содержание
Задача
Инфраструктура
Сайт
Мониторинг
Логи
Сеть
Резервное копирование
Дополнительно
Выполнение работы
Критерии сдачи
Как правильно задавать вопросы дипломному руководителю

### Задача
Ключевая задача — разработать отказоустойчивую инфраструктуру для сайта, включающую мониторинг, сбор логов и резервное копирование основных данных. Инфраструктура должна размещаться в Yandex Cloud и 
отвечать минимальным стандартам безопасности: запрещается выкладывать токен от облака в git. Используйте инструкцию.
Перед началом работы над дипломным заданием изучите Инструкция по экономии облачных ресурсов.

### Инфраструктура
Для развёртки инфраструктуры используйте Terraform и Ansible.

Не используйте для ansible inventory ip-адреса! Вместо этого используйте fqdn имена виртуальных машин в зоне ".ru-central1.internal". Пример: example.ru-central1.internal

Важно: используйте по-возможности минимальные конфигурации ВМ:2 ядра 20% Intel ice lake, 2-4Гб памяти, 10hdd, прерываемая.
Так как прерываемая ВМ проработает не больше 24ч, перед сдачей работы на проверку дипломному руководителю сделайте ваши ВМ постоянно работающими.

Ознакомьтесь со всеми пунктами из этой секции, не беритесь сразу выполнять задание, не дочитав до конца. Пункты взаимосвязаны и могут влиять друг на друга.

### Сайт

Создайте две ВМ в разных зонах, установите на них сервер nginx, если его там нет. ОС и содержимое ВМ должно быть идентичным, это будут наши веб-сервера.
Используйте набор статичных файлов для сайта. Можно переиспользовать сайт из домашнего задания.

Создайте Target Group, включите в неё две созданных ВМ.

Создайте Backend Group, настройте backends на target group, ранее созданную. Настройте healthcheck на корень (/) и порт 80, протокол HTTP.

Создайте HTTP router. Путь укажите — /, backend group — созданную ранее.

Создайте Application load balancer для распределения трафика на веб-сервера, созданные ранее. Укажите HTTP router, созданный ранее, задайте listener тип auto, порт 80.

Протестируйте сайт curl -v <публичный IP балансера>:80

### Мониторинг

Создайте ВМ, разверните на ней Zabbix. На каждую ВМ установите Zabbix Agent, настройте агенты на отправление метрик в Zabbix.

Настройте дешборды с отображением метрик, минимальный набор — по принципу USE (Utilization, Saturation, Errors) для CPU, RAM, диски, сеть, http запросов к веб-серверам. Добавьте необходимые tresholds на соответствующие графики.

### Логи
Cоздайте ВМ, разверните на ней Elasticsearch. Установите filebeat в ВМ к веб-серверам, настройте на отправку access.log, error.log nginx в Elasticsearch.

Создайте ВМ, разверните на ней Kibana, сконфигурируйте соединение с Elasticsearch.

### Сеть
Разверните один VPC. Сервера web, Elasticsearch поместите в приватные подсети. Сервера Zabbix, Kibana, application load balancer определите в публичную подсеть.

Настройте Security Groups соответствующих сервисов на входящий трафик только к нужным портам.

Настройте ВМ с публичным адресом, в которой будет открыт только один порт — ssh. Эта вм будет реализовывать концепцию bastion host . Синоним "bastion host" - "Jump host". Подключение ansible к серверам web и Elasticsearch через данный bastion host можно сделать с помощью ProxyCommand . Допускается установка и запуск ansible непосредственно на bastion host.(Этот вариант легче в настройке)

Резервное копирование
Создайте snapshot дисков всех ВМ. Ограничьте время жизни snaphot в неделю. Сами snaphot настройте на ежедневное копирование.



# Дипломная работа
### Terraform
Установил Terraform на свою виртуальную машину

Создал файл конфигурации с правами.

nano ~/.terraformrc

chmod 644 .terraformrc

Создал файл в директории terraform /main.tf и внес внего свои данные от Yandex Cloud.

Запускаем команду terraform init

![terra](https://github.com/fczalex7/sys-diplom_sys-23/assets/141554023/7a7fb4e8-d513-4c46-af2a-f21e6d90b395)

Создал публичный ключ с помощью команды:
ssh-keygen -t ed25519 и добавил его в meta.yaml

Запускаем команду terraform plan увидев что ошибок нет , запускаем  terraform apply.

![terra2](https://github.com/fczalex7/sys-diplom_sys-23/assets/141554023/fe864162-686b-4573-9242-d52ddf44d9b5)

Видем что завершилось успешно и виртуальные машины и вся инфраструктура созданы.
#### Облако

![облако](https://github.com/fczalex7/sys-diplom_sys-23/assets/141554023/314e07a8-e4fe-411f-8ac3-8e3f2e3f300b)

#### Виртуальные машины

![vm1](https://github.com/fczalex7/sys-diplom_sys-23/assets/141554023/3fabaab4-5cbb-4a72-aea9-0ee0c02a2fbc)

#### Группа безопасноти 

![90](https://github.com/fczalex7/sys-diplom_sys-23/assets/141554023/8b88a1c8-de60-47a1-9df1-843c0c311644)

#### Балансировщик

![баланс](https://github.com/fczalex7/sys-diplom_sys-23/assets/141554023/6238a320-ed45-4122-963f-6dbc86f76cdb)

#### Snapshot дисков

![snap](https://github.com/fczalex7/sys-diplom_sys-23/assets/141554023/0534d35f-1cf2-4036-9877-46fa612049a6)


#### Тестирование сайта curl -v 158.160.155.15:80

![curl](https://github.com/fczalex7/sys-diplom_sys-23/assets/141554023/93aaa610-142e-41cb-a769-01d3626d0341)

### Ansible 

Скачиваем установочные пакеты elasticsearch, filebeat, kibana из ресурса Yandex зеркало/

Конфигурируем файл /ansible.cfg  в дериктории /etc/ansible

Пингуем машины из списка hosts

ansible all -m ping

![ping vm](https://github.com/fczalex7/sys-diplom_sys-23/assets/141554023/a47ed37f-f426-4a44-8093-214d9ee5850c)

Установка roles and collection на хост 

![play1](https://github.com/fczalex7/sys-diplom_sys-23/assets/141554023/df524ec1-4ca5-44fe-98dc-bb3a9e83cb1a)

Установка через ansible 
### Kibana

![kibana](https://github.com/fczalex7/sys-diplom_sys-23/assets/141554023/878b79c1-a813-4a30-a9b6-18c539ddcf80)

### Elasticsearch

![elastic](https://github.com/fczalex7/sys-diplom_sys-23/assets/141554023/e36fafed-61f9-45f4-aa23-855c9490a974)

### Zabbix 

![яфииш](https://github.com/fczalex7/sys-diplom_sys-23/assets/141554023/29746158-1161-4b5a-a722-2c83f04b26c3)
### 2 webserver

![Установка 2 веб сервера](https://github.com/fczalex7/sys-diplom_sys-23/assets/141554023/5cd1f9cc-2b5d-4bad-bf92-3beeda729453)

### filebeat 
![filebeat](https://github.com/fczalex7/sys-diplom_sys-23/assets/141554023/bb6f510d-2c79-4f18-a2df-b1aef57c6628)


### Zabbix-agent

![zabbixagent](https://github.com/fczalex7/sys-diplom_sys-23/assets/141554023/09594319-d561-4cea-9155-6acf8ffa6448)


### Соединение с Elasticsearch
![elk](https://github.com/fczalex7/sys-diplom_sys-23/assets/141554023/7b0e11cf-77aa-4ca3-9303-cf97a638b0df)

![elk1](https://github.com/fczalex7/sys-diplom_sys-23/assets/141554023/bcba93de-4920-4b18-9e3f-1ee881e14dea)

### Zabbix 
http://158.160.109.24/zabbix/
Admin
zabbix

![zabbix1](https://github.com/fczalex7/sys-diplom_sys-23/assets/141554023/b4b030e8-b5c2-45c8-bbe6-ea78b9f2bf4c)

![zabbix3](https://github.com/fczalex7/sys-diplom_sys-23/assets/141554023/954bc5a0-2859-4946-9f10-b2c8b4a99182)










