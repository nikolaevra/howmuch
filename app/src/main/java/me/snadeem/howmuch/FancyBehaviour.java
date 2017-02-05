package me.snadeem.howmuch;

import android.content.Context;
import android.support.design.widget.CoordinatorLayout;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.view.View;

/**
 * Created by Subhan Nadeem on 2017-02-05.
 */

public class FancyBehaviour<V extends View>
        extends CoordinatorLayout.Behavior<V> {
    /**
     * Default constructor for instantiating a FancyBehavior in code.
     */
    public FancyBehaviour() {
    }
    /**
     * Default constructor for inflating a FancyBehavior from layout.
     *
     * @param context The {@link Context}.
     * @param attrs The {@link AttributeSet}.
     */
    public FancyBehaviour(Context context, AttributeSet attrs) {
        super(context, attrs);
        // Extract any custom attributes out
        // preferably prefixed with behavior_ to denote they
        // belong to a behavior
    }

    @Override
    public boolean onTouchEvent(CoordinatorLayout parent, V child, MotionEvent ev) {
        return super.onTouchEvent(parent, child, ev);
    }

    @Override
    public boolean blocksInteractionBelow(CoordinatorLayout parent, V child) {
      /*  return super.blocksInteractionBelow(parent, child);*/
        return false;
    }
}