vocpath = 'P:\prec\VOCtest_06-Nov-2007\VOCdevkit\VOC2007\';
hogpath = 'P:\HoGOutput\HoGOutput\';
disp(vocpath);
disp(hogpath);
disp('making job list');
things = buildJobList(vocpath, hogpath);
disp('making job list complete');

disp('building LDA input paramaters');
ldaInput = buildLDAInputData(hogpath,things.data);
disp('LDA Input paramaters set');

disp('training LDA');
trainworked = 1.;
try
  obj = ClassificationDiscriminant.fit(ldaInput.data, ldaInput.labels, 'discrimType','pseudoLinear');
  disp('LDA training complete');
catch err
    trainworked = 0.;
    disp('LDA training failed');
end

disp('TESTING LDA');
prediction = '';
count = 0.;
passcount = 0.;
if( trainworked == 1 )
    target = 'dog';
    count = count +1.;
    
    for i=1:10
        count = i;
    	thething = things(i,:);
        if( test( thething,  ldaInput.dataheight, obj, thething(2) )  )
                    disp(strcat(thething(2), ' test passed'));
            passcount = passcount +1.;
        else
            disp(strcat(thething(2), ' test failed'));
        end
    end

end
disp(strcat( num2str(passcount), ' out of_ f ', num2str(count), ' tests passed' ));