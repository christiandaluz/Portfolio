import javafx.application.Application;
import javafx.stage.Stage;
import javafx.scene.*;
import javafx.scene.layout.*;  // VBox, HBox, GridPane, BorderPane
import javafx.geometry.*;      // Insets, Pos
import javafx.scene.control.*; // Label, TextField, Button, Alert
import javafx.scene.control.Alert.*;
import javafx.event.ActionEvent;
import javafx.scene.input.*;   // KeyCode, KeyCodeCombintion
import javafx.scene.canvas.*;
import javafx.scene.paint.*;
import javafx.beans.value.*;
import javafx.animation.*;
import javafx.stage.FileChooser;
import javafx.stage.FileChooser.ExtensionFilter;
import java.io.File;
import javafx.scene.image.*;
import java.util.ArrayList;
import java.util.Scanner;
import java.io.PrintWriter;
import java.io.StringWriter;

/**
 *   Class: GameOfLife.java
 *   Author: Christian da Luz
 *   
 *   This application is a user interactive simulation of Conway's Game of Life
 */ 
public class GameOfLife extends Application 
{
    public static void main(String[] args) 
    {
        try
        {
            launch(args);
        }
        catch (Exception error)
        {
            error.printStackTrace();
        }
        finally
        {
            System.exit(0);
        }
    }

    //Grid parameters
    int lineWidth = 2;
    int cellSize = 12;

    int cellsAcross = 96;
    int cellsDown   = 32;

    int width  = cellsAcross * (lineWidth + cellSize);
    int height = cellsDown   * (lineWidth + cellSize);

    Node[][] nodeGrid = new Node[cellsAcross][cellsDown];

    //Set up canvas, graphics context
    Canvas canvas = new Canvas(width, height);
    GraphicsContext context = canvas.getGraphicsContext2D();

    //Boolean used to determine if the simulation should be running automatically or not
    boolean isRunning = false;

    //Variables for handling the simulation running automatically
    double elapsedTime = 0.0;
    double speed = 1.0;

    public void start(Stage mainStage) 
    {
        mainStage.setTitle("Conway's Game of Life");

        BorderPane root = new BorderPane();

        VBox centerBox = new VBox();
        centerBox.setPadding( new Insets(16) );
        centerBox.setSpacing(8);
        centerBox.setAlignment( Pos.CENTER );
        centerBox.setStyle( "-fx-background-color: rgb(80%,80%,100%); -fx-font-size: 16;" );

        //ScrollPane because simulation is rather large and may not be sized appropriately for all
        //  computer screens
        ScrollPane scrollPane = new ScrollPane(centerBox);

        root.setCenter(scrollPane);

        Scene mainScene = new Scene(root);
        mainStage.setScene( mainScene );

        Label title = new Label("Conway's Game of Life");
        title.setStyle("-fx-font-size:32; -fx-font-weight: bold;");

        context.setFill(Color.WHITE);
        context.setLineWidth(lineWidth);
        context.setStroke(Color.BLACK);

        //Create initial background
        context.fillRect(0,0, width,height);
        drawLines(context);

        //Fill the node grid with start and end x and y values
        for (int x = 0; x < cellsAcross; x++) {
            for (int y = 0; y < cellsDown; y++) {
                nodeGrid[x][y] = new Node(  lineWidth*x + cellSize*x + lineWidth/2, 
                    lineWidth*y + cellSize*y + lineWidth/2, 
                    lineWidth*x + cellSize*x + lineWidth/2 + cellSize, 
                    lineWidth*y + cellSize*y + lineWidth/2 + cellSize);
            }
        }

        //If the user clicks on the canvas, the square they click should be toggled either on or off
        canvas.setOnMousePressed( 
            (MouseEvent event) ->
            {
                double ex = event.getX();
                double ey = event.getY();

                for (int x = 0; x < cellsAcross; x++) {
                    for (int y = 0; y < cellsDown; y++) {
                        if (nodeGrid[x][y].overlaps(ex, ey)) {
                            toggleStateAndColor(x, y);
                            break;
                        }
                    }
                }
            }
        );

        //Create an HBox for slider and a label
        HBox sliderBox = new HBox();
        sliderBox.setSpacing(16);
        sliderBox.setAlignment(Pos.CENTER);

        Label speedLabel = new Label("Speed:");

        //Speed Controls via slider
        Slider speedSlider = new Slider();
        speedSlider.setMin(1);
        speedSlider.setMax(10);
        speedSlider.setValue(1);
        speedSlider.setShowTickLabels(true);
        speedSlider.setShowTickMarks(true);
        speedSlider.setMajorTickUnit(1);
        speedSlider.setPrefWidth(300);

        //Change the speed the simulation should run at based on the slider value
        speedSlider.valueProperty().addListener(
            (ObservableValue<? extends Object> ov, Object oldValue, Object newValue) ->
            {
                speedSlider.setValue(Math.round(speedSlider.getValue()));
                speed = speedSlider.getValue();
            }
        );

        sliderBox.getChildren().addAll(speedLabel, speedSlider);

        //Set up the AnimationTimer to run the next generation method after a certain amount of time
        //  has elapsed
        AnimationTimer timer = new AnimationTimer()
            {
                public void handle(long nanoseconds) {
                    elapsedTime += 1/60.0;

                    //When elapsed time passes (one over the speed), go to the next generation
                    if (elapsedTime >= 1.0/speed) {
                        nextGeneration();
                        elapsedTime = 0;
                    }
                }
            };

        //Set up box to hold control buttons
        HBox controlBox = new HBox();
        controlBox.setSpacing(16);
        controlBox.setAlignment(Pos.CENTER);

        //Create next Button
        Button nextButton = new Button("Next Generation");
        nextButton.setOnAction(
            (ActionEvent e) -> {
                nextGeneration();
            }
        );

        //Create start Button
        Button startButton = new Button("Start Simulation");
        startButton.setOnAction( 
            (ActionEvent e) -> {
                timer.start();
            }
        );

        //Create stop Button
        Button pauseButton = new Button("Pause Simulation");
        pauseButton.setOnAction(
            (ActionEvent e) -> {
                timer.stop();
                elapsedTime = 0.0;
            }
        );

        //Create reset Button
        Button resetButton = new Button("Reset Simulation");
        resetButton.setOnAction(
            (ActionEvent e) -> {
                //Any node that is on should be turned off
                for (int x = 0; x < cellsAcross; x++) {
                    for (int y = 0; y < cellsDown; y++) {
                        if (nodeGrid[x][y].isOn()) {
                            toggleStateAndColor(x, y);
                        }
                    }
                }
                timer.stop();
                elapsedTime = 0;
            }
        );

        controlBox.getChildren().addAll(nextButton, startButton, pauseButton, resetButton);

        //Rules pulled from https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life
        Label rules = new Label(
            "Conway's Game of Life follows 4 simple rules:\n" +
            "1. Any live cell with fewer than two live neighbours dies, " + 
                "as if caused by underpopulation.\n" +
            "2. Any live cell with two or three live neighbours lives on to the next generation.\n" +
            "3. Any live cell with more than three live neighbours dies, as if by overpopulation.\n" +
            "4. Any dead cell with exactly three live neighbours becomes a live cell, " +
                "as if by reproduction."
        );

        centerBox.getChildren().addAll(title, canvas, controlBox, sliderBox, rules);

        //Load an inital configuration
        try
        {
            //This is the contents of /configurations/sample.cnfg
            //It cannot be opened while enclosed in the jar file
            Scanner scan = new Scanner(
                "0 1 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 "+
                "1 0 1 0 0 1 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 "+
                "1 0 1 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 "+
                "0 1 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 "+
                "0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 "+
                "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 "+
                "0 1 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 1 0 0 0 1 0 1 1 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 "+
                "1 0 1 0 0 1 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 "+
                "0 1 0 0 0 1 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 1 0 1 0 0 0 0 0 0 0 0 "+
                "0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 0 0 0 0 0 0 0 0 "+
                "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 0 0 0 0 0 0 0 0 "+
                "0 1 0 0 0 0 0 0 0 0 0 0 0 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 0 0 0 0 0 0 0 0 "+
                "1 0 1 0 0 0 0 1 0 0 0 0 0 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 1 0 1 0 0 0 0 0 0 0 0 "+
                "0 1 1 0 0 0 1 0 1 0 0 0 0 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 "+
                "0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 0 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 "+
                "0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 "+
                "1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 "+
                "1 0 1 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 "+
                "0 1 1 0 0 1 1 0 0 0 1 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 "+
                "0 0 0 0 0 0 0 0 0 0 1 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 "+
                "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 1 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 "+
                "0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 1 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 "+
                "0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 "+
                "0 1 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 "+
                "0 0 1 1 0 0 0 0 1 1 0 0 0 0 1 1 0 0 0 1 1 1 1 0 0 0 1 1 0 0 0 0 0 0 0 1 0 0 0 0 1 0 1 1 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 "+
                "1 1 0 0 0 0 0 0 0 0 0 0 0 1 0 0 1 0 1 0 0 0 0 1 0 1 0 0 1 0 0 0 0 0 0 1 0 0 1 0 1 0 1 1 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 "+
                "0 0 1 0 0 0 0 0 0 0 0 0 1 0 1 0 1 0 1 1 0 0 0 1 0 1 0 1 0 1 0 0 1 1 0 1 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 "+
                "0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 1 0 1 0 0 0 0 1 0 1 0 0 1 0 0 0 1 1 0 1 0 1 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 "+
                "0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 1 1 1 1 0 0 0 1 1 0 0 0 0 0 0 0 0 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 "+
                "0 1 0 0 0 0 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 "+
                "0 1 0 0 0 1 1 1 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 "+
                "0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 "
            );

            for (int y = 0; y < cellsDown; y++) {
                for (int x = 0; x < cellsAcross; x++) {
                    int i = scan.nextInt();

                    //1 represents on, 0 represents off
                    //Set each cell of the nodeGrid to whatever is plotted in the file
                    if (i == 1) {
                        nodeGrid[x][y].setState(true);
                        context.setFill(Color.FORESTGREEN);
                    } else if (i == 0) {
                        nodeGrid[x][y].setState(false);
                        context.setFill(Color.WHITE);
                    }

                    //Fill in the node
                    context.fillRect(nodeGrid[x][y].getStartX(), nodeGrid[x][y].getStartY(), 
                        cellSize, cellSize);
                }
            }

            scan.close();
        }
        catch (Exception error)
        {
            StringWriter sw = new StringWriter();
            PrintWriter pw = new PrintWriter(sw);
            error.printStackTrace(pw);
            errorAlert("File Error", null, "Unable to load the sample configuration file.\n" 
                    + sw.toString()
                );
        }

        //Create MenuBar
        MenuBar menuBar = new MenuBar();
        root.setTop(menuBar);
        menuBar.setStyle( "-fx-font-size: 12;" );

        //Create file menu and add its corresponding menuItems
        Menu fileMenu = new Menu("File");
        menuBar.getMenus().add(fileMenu);

        //Set up file chooser with an SVG extension filter
        FileChooser fileChooser = new FileChooser();
        ExtensionFilter cnfgFilter = new ExtensionFilter("Configuration Files", "*.cnfg");
        fileChooser.getExtensionFilters().add(cnfgFilter);

        //Create load menu item
        MenuItem loadItem = new MenuItem("Load Configuration File");
        loadItem.setOnAction(
            (ActionEvent e) -> {
                File f = fileChooser.showOpenDialog(mainStage);

                if (f == null)
                    return;

                try
                {
                    Scanner scan = new Scanner(f);
                    timer.stop();

                    for (int y = 0; y < cellsDown; y++) {
                        for (int x = 0; x < cellsAcross; x++) {
                            int i = scan.nextInt();

                            //1 represents on, 0 represents off
                            //Set each cell of the nodeGrid to whatever is plotted in the file
                            if (i == 1) {
                                nodeGrid[x][y].setState(true);
                                context.setFill(Color.FORESTGREEN);
                            } else if (i == 0) {
                                nodeGrid[x][y].setState(false);
                                context.setFill(Color.WHITE);
                            }

                            //Fill in the node
                            context.fillRect(nodeGrid[x][y].getStartX(), nodeGrid[x][y].getStartY(), 
                                cellSize, cellSize);
                        }
                    }

                    scan.close();
                }
                catch (Exception error)
                {
                    errorAlert("File Error", null, "Unable to load the file " + f.getName() );
                }
            }
        );
        loadItem.setGraphic( new ImageView( new Image("icons/folder.png") ) );
        loadItem.setAccelerator(
            new KeyCodeCombination(KeyCode.L, KeyCombination.CONTROL_DOWN) );
        fileMenu.getItems().add(loadItem);

        //Create save menu item
        MenuItem saveItem = new MenuItem("Save Configuration");
        saveItem.setOnAction(
            (ActionEvent event) ->
            {
                File f = fileChooser.showSaveDialog(mainStage);

                if (f == null) 
                    return;

                try
                {
                    PrintWriter pw = new PrintWriter(f);
                    for (int y = 0; y < cellsDown; y++) {
                        for (int x = 0; x < cellsAcross; x++) {
                            if (nodeGrid[x][y].isOn()) {
                                pw.print("1 ");
                            } else {
                                pw.print("0 ");
                            }
                        }
                        pw.print("\n");
                    }

                    pw.close();
                }
                catch (Exception error)
                {
                    error.printStackTrace();
                }
            }
        );
        saveItem.setGraphic( new ImageView( new Image("icons/disk.png") ) );
        saveItem.setAccelerator(
            new KeyCodeCombination(KeyCode.S, KeyCombination.CONTROL_DOWN) );
        fileMenu.getItems().add(saveItem);

        //Create Help menu item
        MenuItem helpItem = new MenuItem("Help");
        helpItem.setOnAction(
            (ActionEvent event) ->
            {
                Alert aboutAlert = new Alert(AlertType.INFORMATION);
                aboutAlert.setTitle("John Conway's Game of Life: Instructions");
                aboutAlert.setHeaderText("What in tarnation is the Game of Life?"); 

                Stage alertStage = (Stage) aboutAlert.getDialogPane().getScene().getWindow();
                alertStage.getIcons().add( new Image("icons/help.png") );

                aboutAlert.setContentText(
                    "The Game of Life is a cellular automaton designed by John Conway, a British " +
                    "mathematician, in 1970. The user creates an initial configuration and then " +
                    "observes its evolution.\n\n" +
                    "How to use this application:\n" +
                    "Consider any white cell \"off\" or \"dead\" and consider any green cell \"on\" " +
                    "or \"live.\" Clicking on any cell toggles it to its opposite state, either " +
                    "\"on/live\" or \"off/dead\". The 8 cells surrounding each cell are its " +
                    " neighbors.\n\n" +
                    "The simulation progresses via generations; each step in time " +
                    "triggers the next generation and the next generation is determined by a set " +
                    "of rules:\n" +
                    "1. Any live cell with fewer than two live neighbours dies, as if " +
                    "caused by underpopulation.\n" + 
                    "2. Any live cell with two or three live neighbours lives on to the next " +
                    "generation.\n" + 
                    "3. Any live cell with more than three live neighbours dies, as if by " +
                    "overpopulation.\n" +
                    "4. Any dead cell with exactly three live neighbours becomes a live cell, " + 
                    "as if by reproduction.\n\n" +
                    "Selecting \"Next Generation\" progresses to the next step in time.\n" +
                    "Selecting \"Start Simulation\" runs the simulation automatically.\n" +
                    "Selecting \"Pause Simulation\" stops the simulation if it is running.\n" +
                    "Selecting \"Reset Simulation\" clears the grid so that every cell is off.\n" +
                    "Selecting a higher speed value on the slider make the simulation run faster.\n" +
                    "Configurations can be saved or loaded onto the grid using their corresponding " +
                    "File menu items."
                );
                aboutAlert.showAndWait();
            }
        );
        //Add Help icon
        helpItem.setGraphic( new ImageView( new Image("icons/help.png") ) );
        helpItem.setAccelerator(
            new KeyCodeCombination(KeyCode.H, KeyCombination.ALT_DOWN) );
        fileMenu.getItems().add(helpItem);

        //Create About menu item
        MenuItem aboutItem = new MenuItem("About this program");
        aboutItem.setOnAction(
            (ActionEvent event) ->
            {
                Alert aboutAlert = new Alert(AlertType.INFORMATION);
                aboutAlert.setTitle("About this program");
                aboutAlert.setHeaderText(null); 

                Stage alertStage = (Stage) aboutAlert.getDialogPane().getScene().getWindow();
                alertStage.getIcons().add( new Image("icons/world.png") );

                // the graphic replaces the standard icon on the left
                aboutAlert.setGraphic( new ImageView( new Image("icons/me.png", 32, 32, true, true) ) );

                aboutAlert.setContentText("Program designed by Christian da Luz.");
                aboutAlert.showAndWait();
            }
        );
        //Add About icon
        aboutItem.setGraphic( new ImageView( new Image("icons/information.png") ) );
        aboutItem.setAccelerator(
            new KeyCodeCombination(KeyCode.A, KeyCombination.ALT_DOWN) );
        fileMenu.getItems().add(aboutItem);

        //Create Quit item
        MenuItem quitItem = new MenuItem("Quit");
        quitItem.setOnAction( (ActionEvent event) -> System.exit(0) );
        //Add Quit graphic
        quitItem.setGraphic( new ImageView( new Image("icons/door_out.png") ) );
        quitItem.setAccelerator(
            new KeyCodeCombination(KeyCode.Q, KeyCombination.CONTROL_DOWN) );
        fileMenu.getItems().add(quitItem);

        mainStage.show();
    }

    //Draw boundary lines
    public void drawLines(GraphicsContext context) {
        //Draw horizontal lines
        for (int i = 0; i < height; i++) {
            context.strokeLine(0, lineWidth*i + cellSize*i, width, lineWidth*i + cellSize*i);
        }

        //Draw vertical lines
        for (int i = 0; i < width; i++) {
            context.strokeLine(lineWidth*i + cellSize*i, 0, lineWidth*i + cellSize*i, height);
        }
    }

    //Determines the next generation
    //  Code modified from http://www.geeksforgeeks.org/program-for-conways-game-of-life/
    public void nextGeneration() {
        boolean[][] future = new boolean[cellsAcross][cellsDown];

        //Check each node
        for (int x = 0; x < cellsAcross; x++) {
            for (int y = 0; y < cellsDown; y++) {
                int aliveNeighbors = 0;

                //Check each of the nodes around the cell
                for (int i = -1; i <= 1; i++) {
                    for (int j = -1; j <= 1; j++) {
                        //Check Bounds
                        if (x+i >= 0 && x+i < cellsAcross && y+j >= 0 && y+j < cellsDown) {
                            //If a neighbor is alive, increment aliveNeighbors 
                            if (nodeGrid[x+i][y+j].isOn()) {
                                aliveNeighbors++;
                            }
                        }
                    }
                }

                //Subtract 1 from aliveNeighbors if the node was on
                //      If the node was on, it was counted as a neighbor to itself
                if (nodeGrid[x][y].isOn()) {
                    aliveNeighbors -= 1;
                }

                //Enforce the rules of life
                if (nodeGrid[x][y].isOn() && aliveNeighbors < 2) {
                    future[x][y] = false;
                } else if (nodeGrid[x][y].isOn() && aliveNeighbors > 3) {
                    future[x][y] = false;
                } else if (!nodeGrid[x][y].isOn() && aliveNeighbors == 3) {
                    future[x][y] = true;
                } else {
                    future[x][y] = nodeGrid[x][y].isOn();
                }
            }
        }

        //Make changes to the grid accordingly
        for (int x = 0; x < cellsAcross; x++) {
            for (int y = 0; y < cellsDown; y++) {
                if (nodeGrid[x][y].isOn() != future[x][y]) {
                    toggleStateAndColor(x, y);
                }
            }
        }
    }

    //Toggles the state of the node and the color of the square
    public void toggleStateAndColor(int x, int y) {
        //If the node is "on" then it must be switched "off" visually and vice versa
        if (nodeGrid[x][y].isOn()) {
            context.setFill(Color.WHITE);
        } else {
            context.setFill(Color.FORESTGREEN);
        }

        //Toggle the node to its opposite state
        nodeGrid[x][y].toggle();

        //Fill in the rectangle
        context.fillRect(nodeGrid[x][y].getStartX(), nodeGrid[x][y].getStartY(), 
            cellSize, cellSize);
    }

    //Creates and displays an error alert
    public static void errorAlert(String title, String headerText, String contentText) {
        Alert error = new Alert(AlertType.ERROR);
        error.setTitle(title);
        error.setHeaderText(headerText);
        error.setContentText(contentText);
        error.showAndWait();
    }
}