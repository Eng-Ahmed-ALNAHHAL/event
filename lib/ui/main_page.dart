import 'package:cinema/backend/shared_pref.dart'; // Manages shared preferences (local storage)
import 'package:cinema/models/movie.dart'; // Movie model class
import 'package:cinema/state_management/cubit.dart'; // State management Cubit class
import 'package:cinema/state_management/states.dart'; // App states used with Cubit
import 'package:cinema/ui/add_movie.dart';
import 'package:cinema/ui/login.dart'; // Login page
import 'package:flutter/material.dart'; // Flutter's Material Design components
import 'package:flutter_bloc/flutter_bloc.dart'; // State management using BLoC
import '../components/constants.dart';
import 'movie_details.dart'; // Page for editing movie details

class MainPage extends StatefulWidget {
  const MainPage({super.key}); // Constructor with a key to identify the widget

  @override
  State<MainPage> createState() =>
      _MainPageState(); // Returns the state object (_MainPageState)
}

class _MainPageState extends State<MainPage> {
  final TextEditingController _searchController =
      TextEditingController(); // Controller for search input
  @override
  Widget build(BuildContext context) {
    CubitClass cub = CubitClass.get(
        context);
  // Retrieves the Cubit instance for state management
    return BlocBuilder<CubitClass, AppState>(builder: (context, state) {
      return Scaffold(
          // Basic layout structure
          body: RefreshIndicator(
            onRefresh: () async {
              // استدعاء الدوال المطلوبة
              await CubitClass().getMovies();
              await CubitClass().getGuests();
              await CubitClass().getReservations();

              return;
            },
            child: Padding(
                    padding: const EdgeInsets.all(15.0), // Padding around the content
                    child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MouseRegion(
                    onEnter: (event) => cub.agEmpExpanded(),
                    onExit: (event) => cub.agEmpExpanded(),
                    child: IntrinsicWidth(
                      stepWidth: AppDimensions.d60,
                      stepHeight: AppDimensions.d60,
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(AppDimensions.d50), // Use AppDimensions
                          ),
                          color: AppColors.colorBlue, // Use AppColors
                        ),
                        child: cub.empExpanded
                            ? Row(
                          children: [
                            const CircleAvatar(
                              backgroundImage: NetworkImage(
                                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQrmvSoqEMvs4E-TIgyfMdztZYEdKav-zok1A&s'),
                              radius: AppDimensions.d20, // Use AppDimensions
                            ),
                            const SizedBox(width: AppDimensions.d10), // Use AppDimensions
                            const Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'employee name', // Placeholder for employee's name
                                  style: TextStyle(
                                    fontSize: AppDimensions.d20, // Use AppDimensions
                                    color: AppColors.colorWhite, // Use AppColors
                                  ),
                                ),
                                Text(
                                  'employee position', // Placeholder for employee's position
                                  style: TextStyle(
                                    fontSize: AppDimensions.d10, // Use AppDimensions
                                    color: AppColors.colorWhite, // Use AppColors
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: AppDimensions.d10), // Use AppDimensions
                            MaterialButton(
                              onPressed: () {
                                // SharedPref.setBoolData('isLogin', false).then((value) {
                                //   navigatorReplace(context, const Login()); // Navigate to login page
                                // });
                                cub.firebaseLogOut();
                              },
                              child: const CircleAvatar(
                                backgroundColor: AppColors.colorRed, // Use AppColors
                                radius: AppDimensions.d30, // Use AppDimensions
                                child: Text(
                                  'Logout',
                                  style: TextStyle(
                                    color: AppColors.colorWhite, // Use AppColors
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                            : const Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(
                                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQrmvSoqEMvs4E-TIgyfMdztZYEdKav-zok1A&s'),
                              radius: AppDimensions.d20, // Use AppDimensions
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  MouseRegion(
                    onEnter: (event) => cub.agCornerExpanded(),
                    onExit: (event) => cub.agCornerExpanded(),
                    child: IntrinsicWidth(
                      stepWidth: AppDimensions.d60,
                      stepHeight: AppDimensions.d60,
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(AppDimensions.d50), // Use AppDimensions
                          ),
                          color: AppColors.colorBlue, // Use AppColors
                        ),
                        child: cub.cornerExpanded
                            ? Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            MaterialButton(
                              onPressed: () {
                                navigatorTo(context, const AddMovie());
                              },
                              child: Image.asset(
                                AppTexts.assetsImage('addvid.png'),
                                height: AppDimensions.d40, // Use AppDimensions
                              ),
                            ),
                            const SizedBox(width: AppDimensions.d10), // Use AppDimensions
                            MaterialButton(
                              onPressed: () {},
                              child: Image.asset(
                                AppTexts.assetsImage('addemp.png'),
                                height: AppDimensions.d30, // Use AppDimensions
                              ),
                            ),
                            const SizedBox(width: AppDimensions.d10), // Use AppDimensions
                          ],
                        )
                            : const Icon(Icons.add),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.d30), // Use AppDimensions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    AppTexts.movies, // Use AppTexts
                    style: AppTextStyles.titlesStyle
                  ),
                  if (!cub.isSearchingMovie)
                    IconButton(
                      icon: const Icon(Icons.search), // Use AppColors
                      onPressed: () {
                        cub.movieSearch(); // Toggle the search mode
                      },
                    )
                  else
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: AppTexts.searchHint, // Use AppTexts
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(AppDimensions.d10), // Use AppDimensions
                              ),
                            ),
                            onChanged: (query) {
                              cub.searchMovies(word: query); // Perform search on text change
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.clear, color: AppColors.colorWhite), // Use AppColors
                          onPressed: () {
                            cub.movieSearch(); // Toggle off search mode
                            _searchController.clear(); // Clear the search text
                          },
                        ),
                      ],
                    ),
                ],
              ),
              const Divider(
                thickness: AppDimensions.d1, // Use AppDimensions
                color: AppColors.colorGrey, // Use AppColors
              ),
              const SizedBox(height: AppDimensions.d10), // Use AppDimensions
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: AppDimensions.m8,
                    mainAxisExtent: AppDimensions.d200,
                  ),
                  itemBuilder: (context, index) => itemBuilder(
                      cub.isSearchingMovie
                          ? cub.searchedMovie[index]
                          : cub.movies[index],
                      context),
                  shrinkWrap: true,
                  itemCount: cub.isSearchingMovie
                      ? cub.searchedMovie.length
                      : cub.movies.length,
                ),
              ),
            ],
                    ),

            ),
          ));
    });
  }

  ///CubitClass cub = CubitClass.get(context);: Gets the instance of CubitClass to manage the state.
  // BlocBuilder<CubitClass, AppState>: Listens to state changes and rebuilds the UI accordingly.
  // The Scaffold widget provides the basic layout structure with Padding, Column, Row, and Expanded widgets to organize the layout.
  // MouseRegion: Changes the state of CubitClass when the mouse enters or exits the region, affecting UI expansion.
  // IntrinsicWidth: Ensures the width of child widgets is determined by their content.
  // Container: Styled with BoxDecoration for UI elements like profile and action buttons.
  // GridView.builder: Displays a grid of movies with dynamic content based on whether a search is active.
  Widget itemBuilder(Movie movie, BuildContext context) {
    return MaterialButton(
      onPressed: () {
        navigatorTo(context, MovieDetails(movie: movie)); // Navigate to the MovieDetails page
      },
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(AppDimensions.d5)), // Use dimension for border radius
            child: Image.network(
              movie.photo!,
              width: AppDimensions.d300, // Use dimension for width
              height: AppDimensions.d150, // Use dimension for height
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: AppDimensions.d15), // Use dimension for spacing
          Text(
            movie.name!,
            style: AppTextStyles.descStyle, // Use color from AppColors
          ),
        ],
      ),
    );
  }

}
///itemBuilder constructs each item in the grid.
// MaterialButton: The button widget is used for handling taps.
// ClipRRect: Clips the movie image to a rounded rectangle.
// Image.network: Displays the movie's image from the network.
// Text: Shows the movie's name below the image.