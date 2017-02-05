package me.snadeem.howmuch;

import android.Manifest;
import android.animation.IntEvaluator;
import android.animation.ValueAnimator;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.res.Configuration;
import android.location.Location;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.design.widget.AppBarLayout;
import android.support.design.widget.CollapsingToolbarLayout;
import android.support.design.widget.CoordinatorLayout;
import android.support.design.widget.NavigationView;
import android.support.v4.app.ActivityCompat;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentTransaction;
import android.support.v4.content.ContextCompat;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarDrawerToggle;
import android.support.v7.app.AlertDialog;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.DividerItemDecoration;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.Gravity;
import android.view.MenuItem;
import android.view.View;
import android.view.animation.AccelerateDecelerateInterpolator;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.SeekBar;
import android.widget.TextView;
import android.widget.Toast;

import com.afollestad.materialdialogs.DialogAction;
import com.afollestad.materialdialogs.MaterialDialog;
import com.facebook.login.LoginManager;
import com.google.android.gms.appindexing.Action;
import com.google.android.gms.appindexing.AppIndex;
import com.google.android.gms.appindexing.Thing;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.location.LocationListener;
import com.google.android.gms.location.LocationRequest;
import com.google.android.gms.location.LocationServices;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.model.Circle;
import com.google.android.gms.maps.model.CircleOptions;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.Marker;
import com.google.android.gms.maps.model.MarkerOptions;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.koushikdutta.ion.Ion;

import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.UUID;

import de.hdodenhof.circleimageview.CircleImageView;
import me.grantland.widget.AutofitTextView;

import static java.lang.Double.parseDouble;
import static me.snadeem.howmuch.LoginActivity.facebookName;
import static me.snadeem.howmuch.LoginActivity.imageURL;
import static me.snadeem.howmuch.R.id.amountEdit;
import static me.snadeem.howmuch.R.id.redoButton;

public class MainActivity extends AppCompatActivity implements OnMapReadyCallback,
        GoogleApiClient.ConnectionCallbacks,
        GoogleApiClient.OnConnectionFailedListener,
        LocationListener,
        OnHistoryItemClickListener, GoogleMap.OnMarkerClickListener,
        OnRestaurantItemClickListener {

    public static final int MY_PERMISSIONS_REQUEST_LOCATION = 99;
    public static Location mLastLocation;
    GoogleApiClient mGoogleApiClient;
    Marker mCurrLocationMarker;
    LocationRequest mLocationRequest;
    ArrayList<RestaurantModel> restaurantsList;

    int radiusInMetres = 1000;
    boolean firstLoad = true;
    private GoogleMap mMap;
    private DrawerLayout androidDrawerLayout;
    private ActionBarDrawerToggle actionBarDrawerToggle;
    private ValueAnimator vAnimator;
    private ImageButton redoFAB;
    private GoogleApiClient mClient;
    private RecyclerView mRestaurantRecyclerView;
    private MyRestaurantRecyclerViewAdapter mAdapter;
    private double price;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        vAnimator = new ValueAnimator();

        restaurantsList = new ArrayList<>();

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            checkLocationPermission();
        }

        FragmentManager fm = getSupportFragmentManager();
        WorkaroundMapFragment supportMapFragment = new WorkaroundMapFragment();

        supportMapFragment.setListener((new WorkaroundMapFragment.OnTouchListener() {
            @Override
            public void onTouch() {
                ((CoordinatorLayout) findViewById(R.id.rootCoordinatorLayout))
                        .requestDisallowInterceptTouchEvent(true);

                ((AppBarLayout) findViewById(R.id.rootAppBar))
                        .requestDisallowInterceptTouchEvent(true);

                ((CollapsingToolbarLayout) findViewById(R.id.collapsing_toolbar))
                        .requestDisallowInterceptTouchEvent(true);
            }
        }));
        fm.beginTransaction().replace(R.id.mapContainer, supportMapFragment).commit();
        // Obtain the SupportMapFragment and get notified when the map is ready to be used.
        supportMapFragment.getMapAsync(this);

        showHowMuchDialog();

        redoFAB = (ImageButton) findViewById(redoButton);

        redoFAB.setOnClickListener(view -> showHowMuchDialog());

        initializeDrawer();

        mRestaurantRecyclerView = (RecyclerView) findViewById(R.id.restaurantList);
        mRestaurantRecyclerView.setLayoutManager(new LinearLayoutManager(this));
        mAdapter = new MyRestaurantRecyclerViewAdapter(restaurantsList, this);

        mRestaurantRecyclerView.setAdapter(mAdapter);
        mRestaurantRecyclerView.addItemDecoration(new DividerItemDecoration(this,
                DividerItemDecoration.VERTICAL));

        // ATTENTION: This was auto-generated to implement the App Indexing API.
        // See https://g.co/AppIndexing/AndroidStudio for more information.
        mClient = new GoogleApiClient.Builder(this).addApi(AppIndex.API).build();
    }

    private void showHowMuchDialog() {
        View dialogView = getLayoutInflater().inflate(R.layout.how_much_dialog, null);
        AlertDialog dialog = new AlertDialog.Builder(this).create();
        dialog.setView(dialogView);
        dialog.getWindow().getAttributes().windowAnimations = R.style.DialogAnimation;
        dialog.setCancelable(false);
        dialog.show();

        Button goButton = (Button) dialogView.findViewById(R.id.goButton);
        EditText editText = (EditText) dialogView.findViewById(amountEdit);
        SeekBar seekBar = (SeekBar) dialogView.findViewById(R.id.radiusBar);

        // Clear existing session data
        vAnimator.cancel();
        if (mMap != null) mMap.clear();
        restaurantsList.clear();

        goButton.setOnClickListener(v -> {
            if (!editText.getText().toString().equals("")
                    && parseDouble(editText.getText().toString()) >= 0) {

                dialog.dismiss();
                radiusInMetres = (seekBar.getProgress() + 1) * 1000;
                price = parseDouble(editText.getText().toString());
                if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
                    // TODO: Consider calling
                    //    ActivityCompat#requestPermissions
                    // here to request the missing permissions, and then overriding
                    //   public void onRequestPermissionsResult(int requestCode, String[] permissions,
                    //                                          int[] grantResults)
                    // to handle the case where the user grants the permission. See the documentation
                    // for ActivityCompat#requestPermissions for more details.
                    return;
                }
                mLastLocation = LocationServices.FusedLocationApi.getLastLocation(
                        mGoogleApiClient);
                retrieveInformationFromServer(price, radiusInMetres, mLastLocation.getLatitude(), mLastLocation.getLongitude());
                setAnimationCircleOnCurrentLocationWithRadius();
            } else {
                Toast.makeText(MainActivity.this, "Please enter a valid dollar amount!", Toast.LENGTH_LONG).show();
            }
        });

        TextView radiusText = (TextView) dialogView.findViewById(R.id.radiusNum);
        seekBar.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {

            }

            @Override
            public void onStopTrackingTouch(SeekBar seekBar) {

            }

            @Override
            public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {
                radiusText.setText(String.valueOf(progress + 1));
            }
        });
    }

    private void retrieveInformationFromServer(Double price, int radiusInMetres, double latitude, double longitude) {
        ProgressDialog dialog = ProgressDialog.show(this, "Getting restaurants nearby...",
                "Hang tight, we're doing the math!", true);
        final String URL = "http://138.197.132.178/get-location";
        Ion.with(getApplicationContext())
                .load(URL)
                .setBodyParameter("lat", String.valueOf(latitude))
                .setBodyParameter("lon", String.valueOf(longitude))
                .setBodyParameter("price", String.valueOf(price))
                .setBodyParameter("radius", String.valueOf(radiusInMetres))
                .asJsonObject()
                .setCallback((e, result) -> {
                    vAnimator.start();
                    dialog.dismiss();
                    JsonArray dataArray = result.get("data").getAsJsonArray();

                    for (int i = 0; i < dataArray.size(); ++i) {
                        JsonObject obj = dataArray.get(i).getAsJsonObject();
                        Gson gson = new Gson();
                        RestaurantModel curr = gson.fromJson(obj.toString(), RestaurantModel.class);
                        curr.setDistanceToMyLocation(getDistanceToMyLocation(curr));
                        restaurantsList.add(curr);
                    }

                    mAdapter.notifyDataSetChanged();
                    addMarkersToMap();
                    setZoomToCurrentRadius();
                });
    }

    private double getDistanceToMyLocation(RestaurantModel curr) {
        Location loc1 = new Location("");
        loc1.setLatitude(parseDouble(curr.getLat()));
        loc1.setLongitude(parseDouble(curr.getLon()));

        Location loc2 = new Location("");
        loc2.setLatitude(mLastLocation.getLatitude());
        loc2.setLongitude(mLastLocation.getLongitude());
        String doublestr = (new DecimalFormat("0.00")).format(Math.abs(loc1.distanceTo(loc2)) / 1000);

        return Double.parseDouble(doublestr);
    }

    private void setZoomToCurrentRadius() {
        LatLng l = new LatLng(mLastLocation.getLatitude(), mLastLocation.getLongitude());
        Circle circle = mMap.addCircle(new CircleOptions().
                center(l).radius(radiusInMetres));
        circle.setVisible(false);
        int zoomLevel = 15;
        if (circle != null) {
            double radius = circle.getRadius();
            double scale = radius / 500;
            zoomLevel = (int) (16 - Math.log(scale) / Math.log(2));
        }
        mMap.animateCamera(CameraUpdateFactory.newLatLngZoom(l, zoomLevel));
    }

    private void addMarkersToMap() {

        for (int i = 0; i < restaurantsList.size(); ++i) {
            RestaurantModel curr = restaurantsList.get(i);
            mMap.addMarker(new MarkerOptions()
                    .position(new LatLng(parseDouble(curr.getLat()), parseDouble(curr.getLon())))
                    .title(curr.getRestaurant_name()).snippet(curr.getPhone()));
        }
    }

    private void setAnimationCircleOnCurrentLocationWithRadius() {

        LatLng latLng = new LatLng(mLastLocation.getLatitude(), mLastLocation.getLongitude());
        final Circle circle = mMap.addCircle(new CircleOptions().center(latLng)
                .strokeColor(ContextCompat.getColor(this, R.color.colorPrimary)).radius(radiusInMetres));

        vAnimator.setRepeatCount(ValueAnimator.INFINITE);
        vAnimator.setRepeatMode(ValueAnimator.RESTART);  /* PULSE */
        vAnimator.setIntValues(0, radiusInMetres);
        vAnimator.setDuration(8000);
        vAnimator.setEvaluator(new IntEvaluator());
        vAnimator.setInterpolator(new AccelerateDecelerateInterpolator());
        vAnimator.addUpdateListener(valueAnimator -> {
            float animatedFraction = valueAnimator.getAnimatedFraction();
            circle.setRadius(animatedFraction * radiusInMetres);
        });
    }

    private void initializeDrawer() {
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        getSupportActionBar().setTitle("How Much Hub");
        getSupportActionBar().setHomeButtonEnabled(true);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);

        androidDrawerLayout = (DrawerLayout) findViewById(R.id.drawer_layout);
        actionBarDrawerToggle = new ActionBarDrawerToggle(this, androidDrawerLayout, R.string.app_name, R.string.app_name);
        androidDrawerLayout.addDrawerListener(actionBarDrawerToggle);

        NavigationView navigationView = (NavigationView) findViewById(R.id.navigationView);
        navigationView.setNavigationItemSelectedListener(
                new NavigationView.OnNavigationItemSelectedListener() {
                    @Override
                    public boolean onNavigationItemSelected(MenuItem menuItem) {
                        selectDrawerItem(menuItem);
                        return true;
                    }
                });


        View navHeaderView = navigationView.inflateHeaderView(R.layout.navigation_header);
        AutofitTextView navigationDrawerTitle = (AutofitTextView) navHeaderView.findViewById(R.id.navigationDrawerTitle);
        CircleImageView profilePicture = (CircleImageView) navHeaderView.findViewById(R.id.profile_image);

        Ion.with(this)
                .load(imageURL)
                .asBitmap()
                .setCallback((e, result) -> {

                    if (e != null) {
                        Log.e("profile image error", e.toString());
                        return;
                    }
                    profilePicture.setImageBitmap(result);
                });

        if (navigationDrawerTitle != null) navigationDrawerTitle.setText("Hello, " + facebookName);

    }

    public void selectDrawerItem(MenuItem menuItem) {
        // Create a new fragment and specify the fragment to show based on nav item clicked
        Fragment fragment = null;
        Class fragmentClass = null;
        switch (menuItem.getItemId()) {
            case R.id.historyButton:
                fragmentClass = HistoryFragment.class;
                break;
            case R.id.logOutButton:
                FirebaseAuth.getInstance().signOut();
                LoginManager.getInstance().logOut();
                (getSharedPreferences(getString(R.string.app_name), Context.MODE_PRIVATE))
                        .edit().clear().apply();
                Intent loginIntent = new Intent(this, LoginActivity.class);
                loginIntent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
                loginIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                startActivity(loginIntent);
                finish();
        }

        if (fragmentClass != null) {
            try {
                fragment = (Fragment) fragmentClass.newInstance();
                // Insert the fragment by replacing any existing fragment
                FragmentManager fragmentManager = getSupportFragmentManager();
                FragmentTransaction ft = fragmentManager.beginTransaction();
                ft.replace(R.id.mapContainer, fragment);
                ft.addToBackStack(null);
                ft.commit();

                redoFAB.setVisibility(View.GONE);

                // Highlight the selected item has been done by NavigationView
                menuItem.setChecked(true);
                // Set action bar title
                setTitle(menuItem.getTitle());
                // Close the navigation drawer
                androidDrawerLayout.closeDrawers();
            } catch (Exception e) {
                Log.e("nav", e.toString());
            }
        }
    }

    @Override
    public void onPostCreate(Bundle savedInstanceState) {
        super.onPostCreate(savedInstanceState);
        actionBarDrawerToggle.syncState();
    }

    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);
        actionBarDrawerToggle.onConfigurationChanged(newConfig);
    }

    @Override
    public void onWindowFocusChanged(boolean hasFocus) {
        super.onWindowFocusChanged(hasFocus);
        if (hasFocus && redoFAB != null) redoFAB.setVisibility(View.VISIBLE);
    }

    /**
     * Manipulates the map once available.
     * This callback is triggered when the map is ready to be used.
     * This is where we can add markers or lines, add listeners or move the camera. In this case,
     * we just add a marker near Sydney, Australia.
     * If Google Play services is not installed on the device, the user will be prompted to install
     * it inside the SupportMapFragment. This method will only be triggered once the user has
     * installed Google Play services and returned to the app.
     */
    @Override
    public void onMapReady(GoogleMap googleMap) {
        mMap = googleMap;
        mMap.setMapType(GoogleMap.MAP_TYPE_NORMAL);

        //Initialize Google Play Services
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (ContextCompat.checkSelfPermission(this,
                    Manifest.permission.ACCESS_FINE_LOCATION)
                    == PackageManager.PERMISSION_GRANTED) {
                buildGoogleApiClient();
                mMap.setMyLocationEnabled(true);
            }
        } else {
            buildGoogleApiClient();
            mMap.setMyLocationEnabled(true);
        }

    }

    protected synchronized void buildGoogleApiClient() {
        mGoogleApiClient = new GoogleApiClient.Builder(this)
                .addConnectionCallbacks(this)
                .addOnConnectionFailedListener(this)
                .addApi(LocationServices.API)
                .build();
        mGoogleApiClient.connect();
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        if (item.getItemId() == android.R.id.home) {
            if (androidDrawerLayout.isDrawerOpen(Gravity.LEFT)) {
                androidDrawerLayout.closeDrawer(Gravity.LEFT);
            } else {
                androidDrawerLayout.openDrawer(Gravity.LEFT);
            }

        }
        return super.onOptionsItemSelected(item);
    }

    @Override
    public void onConnected(Bundle bundle) {

        mLocationRequest = new LocationRequest();
        mLocationRequest.setInterval(1000);
        mLocationRequest.setFastestInterval(1000);
        mLocationRequest.setPriority(LocationRequest.PRIORITY_BALANCED_POWER_ACCURACY);
        if (ContextCompat.checkSelfPermission(this,
                Manifest.permission.ACCESS_FINE_LOCATION)
                == PackageManager.PERMISSION_GRANTED) {
            LocationServices.FusedLocationApi.requestLocationUpdates(mGoogleApiClient, mLocationRequest, this);
        }
    }

    @Override
    public void onConnectionSuspended(int i) {

    }

    @Override
    public void onLocationChanged(Location location) {

        mLastLocation = location;
        if (mCurrLocationMarker != null) {
            mCurrLocationMarker.remove();
        }

        LatLng latLng = new LatLng(location.getLatitude(), location.getLongitude());

        //move map camera
        mMap.moveCamera(CameraUpdateFactory.newLatLng(latLng));

        //stop location updates
        if (mGoogleApiClient != null) {
            LocationServices.FusedLocationApi.removeLocationUpdates(mGoogleApiClient, this);
        }

        setAnimationCircleOnCurrentLocationWithRadius();
    }

    @Override
    public void onConnectionFailed(ConnectionResult connectionResult) {

    }

    public boolean checkLocationPermission() {
        if (ContextCompat.checkSelfPermission(this,
                Manifest.permission.ACCESS_FINE_LOCATION)
                != PackageManager.PERMISSION_GRANTED) {

            // Asking user if explanation is needed
            if (ActivityCompat.shouldShowRequestPermissionRationale(this,
                    Manifest.permission.ACCESS_FINE_LOCATION)) {

                // Show an explanation to the user *asynchronously* -- don't block
                // this thread waiting for the user's response! After the user
                // sees the explanation, try again to request the permission.

                //Prompt the user once explanation has been shown
                ActivityCompat.requestPermissions(this,
                        new String[]{Manifest.permission.ACCESS_FINE_LOCATION},
                        MY_PERMISSIONS_REQUEST_LOCATION);


            } else {
                // No explanation needed, we can request the permission.
                ActivityCompat.requestPermissions(this,
                        new String[]{Manifest.permission.ACCESS_FINE_LOCATION},
                        MY_PERMISSIONS_REQUEST_LOCATION);
            }
            return false;
        } else {
            return true;
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode,
                                           String permissions[], int[] grantResults) {
        switch (requestCode) {
            case MY_PERMISSIONS_REQUEST_LOCATION: {
                // If request is cancelled, the result arrays are empty.
                if (grantResults.length > 0
                        && grantResults[0] == PackageManager.PERMISSION_GRANTED) {

                    // permission was granted. Do the
                    // contacts-related task you need to do.
                    if (ContextCompat.checkSelfPermission(this,
                            Manifest.permission.ACCESS_FINE_LOCATION)
                            == PackageManager.PERMISSION_GRANTED) {

                        if (mGoogleApiClient == null) {
                            buildGoogleApiClient();
                        }
                        mMap.setMyLocationEnabled(true);
                    }

                } else {

                    // Permission denied, Disable the functionality that depends on this permission.
                    Toast.makeText(this, "permission denied", Toast.LENGTH_LONG).show();
                }
                return;
            }

            // other 'case' lines to check for other permissions this app might request.
            // You can add here other case statements according to your requirement.
        }
    }

    @Override
    public void onHistoryItemClick() {

    }

    /**
     * ATTENTION: This was auto-generated to implement the App Indexing API.
     * See https://g.co/AppIndexing/AndroidStudio for more information.
     */
    public Action getIndexApiAction() {
        Thing object = new Thing.Builder()
                .setName("Main Page") // TODO: Define a title for the content shown.
                // TODO: Make sure this auto-generated URL is correct.
                .setUrl(Uri.parse("http://[ENTER-YOUR-URL-HERE]"))
                .build();
        return new Action.Builder(Action.TYPE_VIEW)
                .setObject(object)
                .setActionStatus(Action.STATUS_TYPE_COMPLETED)
                .build();
    }

    @Override
    public void onStart() {
        super.onStart();

        // ATTENTION: This was auto-generated to implement the App Indexing API.
        // See https://g.co/AppIndexing/AndroidStudio for more information.
        mClient.connect();
        AppIndex.AppIndexApi.start(mClient, getIndexApiAction());
    }

    @Override
    public void onStop() {
        super.onStop();

        // ATTENTION: This was auto-generated to implement the App Indexing API.
        // See https://g.co/AppIndexing/AndroidStudio for more information.
        AppIndex.AppIndexApi.end(mClient, getIndexApiAction());
        mClient.disconnect();
    }

    @Override
    public boolean onMarkerClick(Marker marker) {
        switch (marker.getId()) {

        }
        return false;
    }

    @Override
    public void onItemClick(RestaurantModel model) {


        MaterialDialog dialog = new MaterialDialog.Builder(this)
                .title("What would you like to do?")
                .positiveText("See Menu")
                .neutralText("Cancel")
                .negativeText("Log Visit")
                .onPositive(new MaterialDialog.SingleButtonCallback() {
                    @Override
                    public void onClick(@NonNull MaterialDialog dialog, @NonNull DialogAction which) {
                        displayMenu(model);
                        dialog.dismiss();
                    }
                })
                .onNegative(new MaterialDialog.SingleButtonCallback() {
                    @Override
                    public void onClick(@NonNull MaterialDialog dialog, @NonNull DialogAction which) {
                        dialog.dismiss();
                    }
                })
                .onNeutral(new MaterialDialog.SingleButtonCallback() {
                    @Override
                    public void onClick(@NonNull MaterialDialog dialog, @NonNull DialogAction which) {
                        logHistoryToFirebase(model);
                        dialog.dismiss();
                    }
                })
                .show();
    }


    private void logHistoryToFirebase(RestaurantModel model) {
        DatabaseReference root = FirebaseDatabase.getInstance().getReference().getRoot().
                child("history").child(FirebaseAuth.getInstance().getCurrentUser().getUid()).child(UUID.randomUUID().toString());
        root.child("timestamp").setValue(System.currentTimeMillis());
        root.child("restaurantName").setValue(model.getRestaurant_name());
        root.child("lat").setValue(model.getLat());
        root.child("lng").setValue(model.getLon());
        root.child("fullness").setValue(0);
        root.child("moneySpent").setValue(0);

        Toast.makeText(this, "Your trip to "+model.getRestaurant_name()+" has been successfully logged!", Toast.LENGTH_LONG).show();
    }

    private void displayMenu(RestaurantModel model) {
        View view = getLayoutInflater().inflate(R.layout.menu_layout, null);

        RecyclerView menuList = (RecyclerView) view.findViewById(R.id.menuList);
        MenuAdapter adapter = new me.snadeem.howmuch.MenuAdapter(model.getMenu_items());
        menuList.setAdapter(adapter);

        menuList.setLayoutManager(new LinearLayoutManager(this));
        menuList.setAdapter(adapter);
        mRestaurantRecyclerView.addItemDecoration(new DividerItemDecoration(this,
                DividerItemDecoration.VERTICAL));
        adapter.notifyDataSetChanged();

        AutofitTextView menuHeader = (AutofitTextView) view.findViewById(R.id.menuHeader);
        menuHeader.setText("For $" + price + ", this is what " + model.getRestaurant_name() + " has to offer");
        AlertDialog dialog = new AlertDialog.Builder(this).create();
        dialog.setView(view);
        dialog.getWindow().getAttributes().windowAnimations = R.style.DialogAnimation;
        dialog.setCancelable(true);
        dialog.show();

        (view.findViewById(R.id.menuDoneButton)).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                dialog.dismiss();
            }
        });
    }
}
