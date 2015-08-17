using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Math as Math;
using Toybox.Lang as Lang;
using Toybox.Time as Time;
using Toybox.Time.Gregorian as Calendar;
using Toybox.ActivityMonitor as Act;
class bubblemoveView extends Ui.WatchFace {

    var particleCount = 10;
    var particles = new [particleCount];
    var minDist = 50;
    var dist;
    var bcolour = {"0"=> Gfx.COLOR_GREEN, "1"=> Gfx.COLOR_DK_GREEN, "2"=> Gfx.COLOR_YELLOW, "3"=> Gfx.COLOR_ORANGE, "4"=> Gfx.COLOR_RED, "5"=> Gfx.COLOR_DK_RED};

    //! Load your resources here
    function onLayout(dc) {
        //setLayout(Rez.Layouts.WatchFace(dc));
    }

    function particle(dc, abl){
        var width, height, x, y, z, acty;
  
        width = dc.getWidth();
        height = dc.getHeight();
   
        for(var i = 0; i < particleCount; i++) {
           x = Math.rand() % width * 2;
           y = Math.rand() % height * 2;
           z = Math.rand() % 1000 * abl;
           particles[i] = [ x, y, z];
        }
    }
    
    //! Restore the state of the app and prepare the view to be shown
    function onShow() {
    }

    function drawParticle(dc, clr){
        for(var i = 0; i < particleCount; i++) {
           //Sys.println(particles[i]);
           var coords = new [3];
           coords = particles[i];
           var x = coords[0];
           var y = coords[1];
           var z = coords[2];     
           var color = bcolour[clr.toString()]; 

           dc.setColor(color, Gfx.COLOR_BLACK);
           dc.fillCircle(x/2, y/2, z/100);
           dc.setColor(Gfx.COLOR_BLACK,Gfx.COLOR_BLACK);
           dc.drawCircle(x/2, y/2, z/100);   
        }
    }
    //! Update the view
    function onUpdate(dc) {
        var width, height;
        var now = Time.now();
        var info = Calendar.info(now, Time.FORMAT_LONG);
        var time = makeClockTime();
        var dateStr = Lang.format("$1$ $2$ $3$", [info.day_of_week, info.month, info.day]);
        var activityInfo;
        var string;
        
        width = dc.getWidth();
        height = dc.getHeight();
        activityInfo = Act.getInfo();
        // Clear the screen
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);
        dc.fillRectangle(0,0,dc.getWidth(), dc.getHeight());
        // Draw the inner circle
		particle(dc, activityInfo.moveBarLevel+1);
        drawParticle(dc, activityInfo.moveBarLevel);

        dc.setColor( Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT );
		dc.drawText(width/1.9, (height/3.3) , Gfx.FONT_NUMBER_THAI_HOT, time, Gfx.TEXT_JUSTIFY_CENTER);
		dc.setColor( Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT );
		dc.drawText(width/1 - 5,(height/1.15),Gfx.FONT_SMALL, dateStr, Gfx.TEXT_JUSTIFY_RIGHT);
	
		//And calories
        string = activityInfo.calories.toString() + " C";
        dc.setColor( Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT );
        dc.drawText( width/20 - 5, (height/1.15), Gfx.FONT_SMALL, string , Gfx.TEXT_JUSTIFY_LEFT);
    }

    //! The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    //! Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }
    //! Get the time from the clock and format it for
    //! the watch face
    hidden function makeClockTime()
    {
        var clockTime = Sys.getClockTime();
        var hour, min, result;

        hour = clockTime.hour % 12;
        hour = (hour == 0) ? 12 : hour;
        min = clockTime.min;

        // You so money and you don't even know it
        return Lang.format("$1$:$2$",[hour, min.format("%02d")]);
    }
}