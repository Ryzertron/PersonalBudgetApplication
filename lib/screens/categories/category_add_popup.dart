import 'package:budget/db/category/category_db.dart';
import 'package:budget/models/categories/model_category.dart';
import 'package:flutter/material.dart';

ValueNotifier<CategoryType> selectedCategory =
    ValueNotifier(CategoryType.income);

showCategoryAdd(BuildContext context) async {
  final categorycontroller = TextEditingController();
  showDialog(
    context: context,
    builder: (ctx) {
      return SimpleDialog(
        title: const Text('Add Category'),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: categorycontroller,
              decoration: const InputDecoration(hintText: 'Category Name'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: const [
                RadioButton(title: 'Income', type: CategoryType.income),
                RadioButton(title: 'Expense', type: CategoryType.expense),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                final name = categorycontroller.text.trim();
                if (name.isEmpty) {
                  return;
                }
                final categorytype = selectedCategory.value;
                final category = CategoryModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: name,
                  type: categorytype,
                );
                CategoryDB().insertCategory(category);
                Navigator.pop(ctx);
              },
              child: const Text('Add'),
            ),
          ),
        ],
      );
    },
  );
}

class RadioButton extends StatelessWidget {
  final String title;
  final CategoryType type;
  const RadioButton({Key? key, required this.title, required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ValueListenableBuilder(
          valueListenable: selectedCategory,
          builder: (BuildContext ctx, CategoryType newcategory, _) {
            return Radio<CategoryType>(
              value: type,
              groupValue: selectedCategory.value,
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                selectedCategory.value = value;
              },
            );
          },
        ),
        Text(title),
      ],
    );
  }
}
