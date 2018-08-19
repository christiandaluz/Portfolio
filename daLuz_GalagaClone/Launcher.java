import com.badlogic.gdx.backends.lwjgl.LwjglApplication;
import com.badlogic.gdx.backends.lwjgl.LwjglApplicationConfiguration;
public class Launcher
{
    public static void main (String[] args)
    {
        LwjglApplicationConfiguration config = new LwjglApplicationConfiguration();
        
        // change configuration settings
        config.width = 450;
        config.height = 650;
        config.title = "GALAGA GALAGA GALAGA GALAGA GALAGA GALAGA GALAGA GALAGA GALAGA " +
            "GALAGA GALAGA GALAGA GALAGA GALAGA GALAGA GALAGA GALAGA GALAGA";
        
        BaseGame myProgram = new SpaceGame();
        LwjglApplication launcher = new LwjglApplication( myProgram, config );
    }
}