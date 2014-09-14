            //27,1
            //9,8
        var tx =27-9
        var ty =1-8
        var tangle = radtodeg(arctan2(ty, tx))
        var th = sqrt(tx*tx+ty*ty)
        
        if image_xscale = 1
        {
            var lx = lengthdir_x(th,-tangle+aimAngle)
            var ly = lengthdir_y(th,-tangle+aimAngle)
            var desx = x-1+lx
            var desy = y+22+ly
            while(GetCollision(desx,desy)<0 and desx>=0 and desx<=room_width and desy >=0 and desy<=room_height and (!collision_point(desx,desy,oPlayer,false,true) or collision_point(desx,desy,oPlayer,false,true).client=false))
            {
                desx += cos(-degtorad(aimAngle))
                desy += sin(-degtorad(aimAngle))
            }
        }
        else
        {
            var lx = lengthdir_x(th,tangle+aimAngle+180)
            var ly = lengthdir_y(th,tangle+aimAngle+180)
            var desx = x-1+lx
            var desy = y+22+ly
            while(GetCollision(desx,desy)<0 and desx>=0 and desx<=room_width and desy >=0 and desy<=room_height and (!collision_point(desx,desy,oPlayer,false,true) or collision_point(desx,desy,oPlayer,false,true).client=false))
            {
                desx += cos(-degtorad(aimAngle+180))
                desy += sin(-degtorad(aimAngle+180))
            }
        }
        if GetCollision(x+1+lx,y+22+ly)<0
            draw_line_colour(x-1 + lx,y+22 + ly,desx,desy,c_red,c_red)
