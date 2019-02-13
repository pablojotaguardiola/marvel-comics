# Marvel Comics
by Pablo Guardiola

This is a Demo App using Marvel comics API. You can found the API documentation here https://developer.marvel.com.

It's a basic App that list all the comics reached from the API.
You can add items to favorites and check them even without internet connection since they are stored in CoreData database.
Important: Items images are stored by Kingfisher caché, so the availability is not guaranteed.

Search by title with the search bar at the top.

## About code

Find useful classes to take ideas for your projects:

Networking.swift: Initialize this class so you can call the "get" method. Pass a Decodable custom class so you'll get directly the object in the response. Customize the enum Operation that will contain the path and the parameters. This works with ReactiveSwift so you'll get a signal, just subscribe to it.

CoreData.swift: CoreData.swift keeps the main context so you can access to it with "CoreData.context". 

CoreData+extensions.swift: Insert, delete or get CoreData objects. Since these extensions are generic you only need your objects to follow CoreDataObject protocol.
These tools are useful for a basic CoreData management, maybe you'll need private contexts if your project grows.

PGCollectionView: A view with a UICollectionView and a title UILabel that you can define only specifying number of rows/columns and the scroll direction.

EmptyTableViewPlaceHolder: This is a helper UIView ready to attach to a collection view bounds in order to show a message in the center when datasource is empty. Just set a icon, title and subtitle and hide the view whenever you want.

Enjoy!
