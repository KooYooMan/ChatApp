import 'package:flutter/material.dart';

class CategorySelector extends StatefulWidget implements PreferredSizeWidget {
  CategorySelector({Key key, @required this.onChanged}) : super(key: key);

  final onChanged;

  @override
  _CategorySelectorState createState() => _CategorySelectorState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(70.0);
}

class _CategorySelectorState extends State<CategorySelector> {
  int selectedIndex = 0;
  final List<String> categories = ['Recent', 'Online', 'Group'];

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        SizedBox(height: 20.0,),
        Container(
          height: 50.0,
          color: Theme.of(context).primaryColor,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                width: MediaQuery.of(context).size.width / categories.length,
                child: FlatButton(

                  onPressed: () {
                    setState(() {
                      selectedIndex = index;
                      widget.onChanged(index);
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: (index == selectedIndex) ? BorderSide(color: Colors.cyan, width: 5.0, style: BorderStyle.solid) : BorderSide.none,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        categories[index],
                        style: TextStyle(
                          color: index == selectedIndex ? Colors.cyan : Colors.grey[200],
                          fontSize: 15.0,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
