import 'package:flutter/material.dart';
import 'package:zc_dodiddon/Theme/theme.dart';
import 'package:zc_dodiddon/Screens/profile.dart';

import '../Screens/all_tasks.dart'; // Импортируем ProfilePage

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    TasksPage(),
    Text('Сегодня'),
    Text('Выполнено'),
    ProfilePage(), // Заменяем Text на ProfilePage
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Функция для показа диалогового окна
  void _showAddTaskDialog() {
    DateTime? selectedDateTime; // Переменная для хранения выбранной даты и времени

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          // Используем Dialog вместо AlertDialog для настройки ширины
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: 400, // Устанавливаем ширину диалогового окна
            padding: const EdgeInsets.all(20), // Добавляем отступ
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Название задачи',
                  ),
                ),
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Описание задачи',
                  ),
                ),
                // Поле для выбора даты и времени
                Padding(
                  padding: const EdgeInsets.only(top: 16), // Отступ для кнопки
                  child: ElevatedButton(
                    onPressed: () async {
                      selectedDateTime = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (selectedDateTime != null) {
                        // После выбора даты показываем диалог выбора времени
                        selectedDateTime = (await showTimePicker(
                          // ignore: use_build_context_synchronously
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(selectedDateTime!),
                        )) as DateTime?;
                      }
                    },
                    child: const Text('Выбрать дедлайн'),
                  ),
                ),
                // Добавьте поля для даты и времени, если нужно
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              DoDidDoneTheme.lightTheme.colorScheme.secondary,
              DoDidDoneTheme.lightTheme.colorScheme.primary,
            ],
          ),
        ),
        child: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Задачи',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Сегодня',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Выполнено',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Профиль',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
