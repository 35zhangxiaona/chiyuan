function degree = degree_Behavior(p_moving, p_static)
if p_moving(1) >= p_static(1)
    if p_moving(2) >= p_static(2)
        degree = 270 + atand(abs(p_moving(2)-p_static(2))/abs(p_moving(1) - p_static(1) )); %��������
    else
        degree =atand(abs(p_moving(2)-p_static(2))/abs(p_moving(1) - p_static(1) )); %��һ����
    end
else
    if   p_moving(2) >= p_static(2)
        degree =180 + atand(abs(p_moving(2)-p_static(2))/abs(p_moving(1) - p_static(1) )); %��������
    else
         degree =180 - atand(abs(p_moving(2)-p_static(2))/abs(p_moving(1) - p_static(1) )); %�ڶ�����
    end
end
end
        